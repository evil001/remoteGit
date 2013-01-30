//
//  CatalogViewController.m
//  IpadLisShow
//
//  Created by Dwen on 13-1-21.
//  Copyright (c) 2013年 Dwen. All rights reserved.
//

#import "CatalogViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "ImageScanViewController.h"
#import "ViewController.h"

//一行显示数量
#define ROW_LIMIT 5
//限制页中显示数量(分页数量须是一页显示数量的倍数)
#define PAGE_LIMIT 15
//最大页码数(1000)
#define PAGE_MAX 10000
//每次请求数量
#define REQUEST_NUMS 60
//列表X限制
#define X_LIMIT 204
//列表Y限制
#define Y_LIMIT 210
//一页的宽度
#define PAGE_WIDTH 1024
//默认加载图片
#define DEFAULT_IMAGE @"w12122.jpg"

@interface CatalogViewController ()

@end

@implementation CatalogViewController
@synthesize scrollView;
@synthesize imgArr,commImgArr,lotArr,commLotArr,closeClostArr,commCloseClostArr,displayMsgArr,commdisplayMsgArr;
@synthesize pageView;
@synthesize navigationBar;
@synthesize requestVO;
@synthesize currentPage,totalNum,totalPage,loadPage,pageNum;
@synthesize specialCode,imageUrl,specialName,specialAuctionTime,specialPreview,specialRemark,specialAddress;
@synthesize receivedData;
@synthesize slider,sliderValue;
@synthesize popover;
@synthesize firstBtn,sortBtn;
@synthesize sdVC,sortVC;
@synthesize isShowSpecial;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil : (NSString *)imgUrl
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self analysisCatalog:imgUrl];
        currentPage = 0;
        commImgArr = [[NSMutableArray alloc] init];
        commLotArr = [[NSMutableArray alloc] init];
        commCloseClostArr = [[NSMutableArray alloc] init];
        commdisplayMsgArr = [[NSMutableArray alloc] init];
        imgArr = [[NSMutableArray alloc] init];
        lotArr = [[NSMutableArray alloc] init];
        closeClostArr = [[NSMutableArray alloc] init];
        displayMsgArr = [[NSMutableArray alloc] init];
        [self initRequestParam];
        [self initRequestData:requestVO];
        scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 35, self.view.frame.size.width, self.view.frame.size.height)];
        [scrollView setDelegate:self];
        scrollView.pagingEnabled = YES;
        [scrollView setScrollEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:scrollView];
        //滑动控件
        //        UIImage *leftTrack = [UIImage imageNamed:@"left.png"];
        //        UIImage *rightTrack = [UIImage imageNamed:@"right.png"];
        //        UIImage *markImg = [UIImage imageNamed:@"mark.png"];
        slider = [[UISlider alloc] initWithFrame:CGRectMake(30, self.view.frame.size.height-72, self.view.frame.size.width-60, 20)];
        [slider setValue:0];
        [slider setMinimumValue:0];
        //        [slider setMaximumValue:20];
        //        [slider setMinimumTrackImage:leftTrack forState:UIControlStateNormal];
        //        [slider setMaximumTrackImage:rightTrack forState:UIControlStateNormal];
        //        [slider setThumbImage:markImg forState:UIControlStateHighlighted];
        //滑动事件
        [slider addTarget:self action:@selector(sliderValueChanged:) forControlEvents:UIControlEventValueChanged];
        [slider addTarget:self action:@selector(sliderDragUp:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:slider];
    }
    return self;
}

- (IBAction)changeSeg:(id)sender {
    //全部
    if ([sender selectedSegmentIndex] == 0) {
        NSLog(@"全部...");
    }
    //关注
    if ([sender selectedSegmentIndex] == 1) {
        NSLog(@"关注...");
    }
    //提醒
    if ([sender selectedSegmentIndex] == 2) {
        NSLog(@"提醒...");
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    isShowSpecial = false;
    self.view.backgroundColor = [UIColor grayColor];
    if (nil == specialName) {
        self.title = @"图录列表";
    }
    [sortBtn setTitle:@"拍品排序" forState:UIControlStateNormal];
    //添加导航右边按钮
    UIToolbar *tools = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 150, 44)];
    [tools setTintColor:[self.navigationController.navigationBar tintColor]];
    [tools setAlpha:[self.navigationController.navigationBar alpha]];
    NSMutableArray *buttons = [[NSMutableArray alloc] initWithCapacity:1];
    firstBtn = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:@selector(showSpecial)];
    [buttons addObject:firstBtn];
    [tools setItems:buttons animated:NO];
    UIBarButtonItem *myBtn = [[UIBarButtonItem alloc] initWithCustomView:tools];
    self.navigationItem.rightBarButtonItem = myBtn;
}

//排序
- (IBAction)sortAction:(id)sender {
    sortVC = [[SortViewController alloc] initWithStyle:UITableViewStylePlain];
    sortVC.contentSizeForViewInPopover = CGSizeMake(250, 200);
    popover = [[UIPopoverController alloc] initWithContentViewController:sortVC];
    [popover presentPopoverFromRect:[self.sortBtn bounds] inView:self.sortBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
    sortVC.popover = self.popover;
    sortVC.specialCode = specialCode;
}

//显示专场内容
- (void)showSpecial{
    if (!isShowSpecial) {
        sdVC = [[SpecialDescriptionViewController alloc] initWithNibName:@"SpecialDescriptionViewController" bundle:nil];
        sdVC.contentSizeForViewInPopover = CGSizeMake(300, 300);
        //TODO 还需排版修改
        sdVC.txtView.text = [NSString stringWithFormat:@"%@ %@ %@ %@",specialAddress,specialAuctionTime,specialPreview,specialRemark];//专场简介
        popover = [[UIPopoverController alloc] initWithContentViewController:sdVC];
        [popover presentPopoverFromBarButtonItem:firstBtn permittedArrowDirections:UIPopoverArrowDirectionAny animated:YES];
        isShowSpecial = true;
    }else{
        [popover dismissPopoverAnimated:YES];//隐藏popoverView
        isShowSpecial = false;
    }
}

//拖动时事件
- (void)sliderValueChanged:(id)sender{
    //    NSLog(@"sliderValueChanged : %f",slider.value);
}

//拖动后事件
- (void)sliderDragUp:(id)sender{
    sliderValue = fabs(slider.value);
    pageNum = sliderValue;
    [self loadNewData:PAGE_WIDTH*pageNum : PAGE_LIMIT*pageNum];
    CGRect frame = self.view.frame;
    frame.origin.x = self.view.frame.size.width*pageNum;
    frame.origin.y = 0;
    [self.scrollView scrollRectToVisible:frame animated:YES];
}

- (void) back{
    ViewController *VC = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
    [self presentModalViewController:VC animated:YES];
}

//解析图片名称为目录名
- (void)analysisCatalog:(NSString *) imgUrlStr{
    NSRange range = [imgUrlStr rangeOfString:@"."];
    if (range.length > 0) {
        specialCode = [[imgUrlStr substringToIndex:range.location] uppercaseString];
    }else{
        specialCode = [imgUrlStr uppercaseString];
    }
}

//初始化请求参数
- (void) initRequestParam{
    if (nil == requestVO) {
        requestVO = [[RequestVO alloc] init];
    }
    [requestVO setClassName:@"AppServiceImpl"];
    [requestVO setMethodName:@"queryAuctionBySpecialCode"];
    [requestVO setSpecialCode:specialCode];
    [requestVO setStart:[NSString stringWithFormat:@"%i",currentPage]];
    [requestVO setEnd:[NSString stringWithFormat:@"%i",PAGE_MAX]];
    
}

//初始化请求数据
- (void) initRequestData : (RequestVO *) requestParam{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *directory = [[NSMutableDictionary alloc]init];
    NSString *paramJson;
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:REQUEST_URL];
    [directory setValue:requestParam.className forKey:@"className"];
    [directory setValue:requestParam.methodName forKey:@"methodName"];
    [paramDic setValue:requestParam.specialCode forKey:@"specialCode"];
    [paramDic setValue:requestParam.start forKey:@"start"];
    [paramDic setValue:requestParam.end forKey:@"end"];
    [directory setValue:paramDic forKey:@"parameter"];
    NSLog(@"[directory description] :%@",[directory description]);
    if ([NSJSONSerialization isValidJSONObject:directory]) {
        NSError *error ;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:directory options:NSJSONWritingPrettyPrinted error:&error];
        paramJson =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        paramJson = [paramJson stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    [urlStr appendString:paramJson];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
    if (connection) {
        receivedData = [[NSMutableData alloc] init];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器连接异常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma connection
//接收响应
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response{
    [receivedData setLength:0];
}

//接收到数据
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data{
    [receivedData appendData:data];
}

//数据加载完成
- (void)connectionDidFinishLoading:(NSURLConnection *)connection{
    NSError *error ;
    NSDictionary *dataDictory = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
//    NSLog(@"dataDictory : %@",[dataDictory description]);
    if (NULL != dataDictory) {
        //拍品信息
        NSMutableDictionary *dic = [dataDictory valueForKey:@"auctionInfo"];
        //专场信息
        NSMutableDictionary *specialdic = [dataDictory valueForKey:@"specialInfo"];
        if ([dic count]>0) {
            if ([imgArr count]>0) {
                commImgArr = [dic valueForKey:@"imageName"];
                [imgArr addObjectsFromArray:commImgArr];
                commLotArr = [dic valueForKey:@"lot"];
                [lotArr addObjectsFromArray:commLotArr];
                commCloseClostArr = [dic valueForKey:@"closeCost"];
                [closeClostArr addObjectsFromArray:commCloseClostArr];
                commdisplayMsgArr = [dic valueForKey:@"displayMessage"];
                [displayMsgArr addObjectsFromArray:commdisplayMsgArr];
            }else{
                [imgArr addObjectsFromArray:[dic valueForKey:@"imageName"]];
                [lotArr addObjectsFromArray:[dic valueForKey:@"lot"]];
                [closeClostArr addObjectsFromArray:[dic valueForKey:@"closeCost"]];
                [displayMsgArr addObjectsFromArray:[dic valueForKey:@"displayMessage"]];
            }
            currentPage = [imgArr count];
            NSString *totalNumStr = [dataDictory valueForKey:@"count"];
            totalNum = [totalNumStr integerValue];
            specialName = [specialdic valueForKey:@"specialName"];//专场名称
            self.title = [NSString stringWithFormat:@"%@(%i件)",specialName,totalNum];
            specialAddress = [specialdic valueForKey:@"address"];
            specialAuctionTime = [specialdic valueForKey:@"auctionTime"];
            specialPreview = [specialdic valueForKey:@"preview"];
            specialRemark = [specialdic valueForKey:@"remark"];
            
            NSLog(@"[imgArr count] :%i ,totalNum : %i",[imgArr count],totalNum);
            [self reLoadPage];
            //页数
            [self getTotalPage];
            [scrollView setContentSize:CGSizeMake(self.view.frame.size.width*totalPage, 500)];
            [slider setMaximumValue:totalPage-1];
            [self loadNewData:PAGE_WIDTH*pageNum : PAGE_LIMIT*pageNum];
        }
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"拍品无数据" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    NSLog(@"Error : %@",error);
}

#pragma 自定义方法
//拍品总页数
- (void)getTotalPage{
    totalPage = totalNum%PAGE_LIMIT==0 ? totalNum/PAGE_LIMIT : totalNum/PAGE_LIMIT+1;
}

//重新加载新的页
- (void)reLoadPage{
    loadPage = [imgArr count]%PAGE_LIMIT==0 ? [imgArr count]/PAGE_LIMIT : [imgArr count]/PAGE_LIMIT+1;
}

//加载下一页新数据
- (void) loadNewData:(float) w :(int)start{
    pageView = [[UIView alloc] initWithFrame:CGRectMake(w, 5, self.view.frame.size.width, self.view.frame.size.height)];
    if (pageNum==(totalPage-1)) {//显示最后一页剩余下来的拍品
        for (int j=start; j< [imgArr count]; j++) {
            CatalogView *catalogView = [[[NSBundle mainBundle] loadNibNamed:@"CatalogView" owner:self options:nil] lastObject];
            [catalogView setFrame:CGRectMake((j%ROW_LIMIT)*X_LIMIT,((j-PAGE_LIMIT*pageNum)/ROW_LIMIT)*Y_LIMIT, catalogView.frame.size.width, catalogView.frame.size.height)];
            catalogView.lotLab.text = [NSString stringWithFormat:@"%@",[lotArr objectAtIndex:j]];
            //成交价
            NSNumber *closeCostStr = [closeClostArr objectAtIndex:j];
            if ([closeCostStr doubleValue] == 0) {
                catalogView.closeCostLab.text = @"成交价 暂无";
            }else{
                catalogView.closeCostLab.text = [NSString stringWithFormat:@"成交价 ￥%f",[closeCostStr doubleValue]];
            }
            NSString *imgPath = [NSString stringWithFormat:AUCTION_LIST_URL,specialCode,[imgArr objectAtIndex:j]];
            [catalogView.indicatorView startAnimating];
            [catalogView.imageView setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE] success:^(UIImage *image){
                [catalogView.indicatorView stopAnimating];
            } failure:^(NSError *error){
                NSLog(@"Image load error :%@",error);
            }];
            
            //添加图片点击事件
            catalogView.imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAuctionDetail:)];
            [catalogView.imageView addGestureRecognizer:tap];
            catalogView.imageView.tag = j;
            
            [catalogView.nameBtn setTitle:[displayMsgArr objectAtIndex:j] forState:UIControlStateNormal];
            [pageView addSubview:catalogView];
            [self.scrollView addSubview:pageView];
        }
    }else if(pageNum==(loadPage-1)){//处理最后一页不是整页的情况
        for (int j=start; j< [imgArr count]; j++) {
            CatalogView *catalogView = [[[NSBundle mainBundle] loadNibNamed:@"CatalogView" owner:self options:nil] lastObject];
            [catalogView setFrame:CGRectMake((j%ROW_LIMIT)*X_LIMIT,((j-PAGE_LIMIT*pageNum)/ROW_LIMIT)*Y_LIMIT, catalogView.frame.size.width, catalogView.frame.size.height)];
            catalogView.lotLab.text = [NSString stringWithFormat:@"%@",[lotArr objectAtIndex:j]];
            //成交价
            NSNumber *closeCostStr = [closeClostArr objectAtIndex:j];
            if ([closeCostStr doubleValue] == 0) {
                catalogView.closeCostLab.text = @"成交价 暂无";
            }else{
                catalogView.closeCostLab.text = [NSString stringWithFormat:@"成交价 ￥%f",[closeCostStr doubleValue]];
            }
            NSString *imgPath = [NSString stringWithFormat:AUCTION_LIST_URL,specialCode,[imgArr objectAtIndex:j]];
            [catalogView.indicatorView startAnimating];
            [catalogView.imageView setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE] success:^(UIImage *image){
                [catalogView.indicatorView stopAnimating];
            } failure:^(NSError *error){
                NSLog(@"Image load error :%@",error);
            }];
            
            //添加图片点击事件
            catalogView.imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAuctionDetail:)];
            [catalogView.imageView addGestureRecognizer:tap];
            catalogView.imageView.tag = j;
            
            [catalogView.nameBtn setTitle:[displayMsgArr objectAtIndex:j] forState:UIControlStateNormal];
            [pageView addSubview:catalogView];
            [self.scrollView addSubview:pageView];
        }
    }else{
        for (int j=start; j<start+PAGE_LIMIT; j++) {
            CatalogView *catalogView = [[[NSBundle mainBundle] loadNibNamed:@"CatalogView" owner:self options:nil] lastObject];
            if (j<PAGE_LIMIT) {
                [catalogView setFrame:CGRectMake((j%ROW_LIMIT)*X_LIMIT,(j/ROW_LIMIT)*Y_LIMIT, catalogView.frame.size.width, catalogView.frame.size.height)];
            }else{
                [catalogView setFrame:CGRectMake((j%ROW_LIMIT)*X_LIMIT,((j-PAGE_LIMIT*pageNum)/ROW_LIMIT)*Y_LIMIT, catalogView.frame.size.width, catalogView.frame.size.height)];
            }
            catalogView.lotLab.text = [NSString stringWithFormat:@"%@",[lotArr objectAtIndex:j]];
            //成交价
            NSNumber *closeCostStr = [closeClostArr objectAtIndex:j];
            if ([closeCostStr doubleValue] == 0) {
                catalogView.closeCostLab.text = @"成交价 暂无";
            }else{
                catalogView.closeCostLab.text = [NSString stringWithFormat:@"成交价 ￥%f",[closeCostStr doubleValue]];
            }
            NSString *imgPath = [NSString stringWithFormat:AUCTION_LIST_URL,specialCode,[imgArr objectAtIndex:j]];
            [catalogView.indicatorView startAnimating];
            [catalogView.imageView setImageWithURL:[NSURL URLWithString:imgPath] placeholderImage:[UIImage imageNamed:DEFAULT_IMAGE] success:^(UIImage *image){
                [catalogView.indicatorView stopAnimating];
            } failure:^(NSError *error){
                NSLog(@"Image load error :%@",error);
            }];
            //添加图片点击事件
            catalogView.imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(goAuctionDetail:)];
            [catalogView.imageView addGestureRecognizer:tap];
            catalogView.imageView.tag = j;
            
            [catalogView.nameBtn setTitle:[displayMsgArr objectAtIndex:j] forState:UIControlStateNormal];
            [pageView addSubview:catalogView];
            [self.scrollView addSubview:pageView];
        }
    }
    
}

//进入拍品详细
- (void) goAuctionDetail:(id)sender{
    NSInteger index = [(UIGestureRecognizer *)sender view].tag;
    NSLog(@"goAuctionDetail........%i",index);
    NSString *imgStr = [imgArr objectAtIndex:index];
    NSLog(@"imgStr =========%@ ",imgStr);
    ImageScanViewController *imageScan = [[ImageScanViewController alloc]init];
    imageScan.specialCode = specialCode;
    [self.navigationController pushViewController:imageScan animated:YES];
}

//下载图络图片
- (UIImage *)downloadImg : (NSString*) imgPath{
    NSData *imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:imgPath]];
    return [[UIImage alloc] initWithData:imageData];
}

#pragma scrollView

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    pageNum = fabs(self.scrollView.contentOffset.x/PAGE_WIDTH);
    [self loadNewData:PAGE_WIDTH*pageNum : PAGE_LIMIT*pageNum];
    NSLog(@"pageNum: %i ,loadPage: %i ,[imgArr count]: %i,totalPage: %i",pageNum,loadPage,[imgArr count],totalPage);
    [slider setValue:pageNum];//设置slider滑杆位置
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    //    NSLog(@"scrollViewDidEndDragging==========");
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
    NSLog(@"scrollViewDidEndScrollingAnimation==========");
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    //    NSLog(@"scrollViewWillBeginDecelerating==========");
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //内存不够
    [imgArr removeAllObjects];
    [lotArr removeAllObjects];
    [closeClostArr removeAllObjects];
    [displayMsgArr removeAllObjects];
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    
}

- (void)viewDidUnload {
    [self setSlider:nil];
    [self setSegBtn:nil];
    [self setSortBtn:nil];
    [super viewDidUnload];
}
@end
