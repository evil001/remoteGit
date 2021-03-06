//
//  ImageScanViewController.m
//  BookReader
//
//  Created by 晓军 唐 on 13-1-24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ImageScanViewController.h"
#import "UIImageView+WebCache.h"
#import "SDImageCache.h"
#import "ViewController.h"
#import "CatalogViewController.h"
#import "Utils.h"
#import "SVProgressHUD.h"

@interface ImageScanViewController ()

@property (strong, nonatomic) NSMutableArray *auctionNameArr,*lotArr,*evaluateCostArr,*metailArr,*closeCostArr,*auctionRemarkArr;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *materialName;
@property (strong, nonatomic) UIButton *guanzhuBtn;
@property (strong, nonatomic) UIButton *xinxiBtn;
@property (strong, nonatomic) NSDictionary *imageDictory;
@property UIDeviceOrientation orientation;
@end

@implementation ImageScanViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize imagesArr,auctionNameArr,lotArr,evaluateCostArr,metailArr,closeCostArr,auctionRemarkArr;
@synthesize specialCode;
@synthesize pageNum,currPage,listIndex;
@synthesize slider;
@synthesize lastScal;
@synthesize imageView;
@synthesize buttomToolBar;
@synthesize topToolBar;
@synthesize topRightBtn;
@synthesize isShowToolBar;
@synthesize auctionName,evaluateCost,lot;
@synthesize xinxiBtn;
@synthesize materialName;
@synthesize guanzhuBtn;
@synthesize auctionSort,orderPa;
@synthesize auctionController;
@synthesize auctionPopover;
@synthesize imageDictory;
@synthesize receivedData;
@synthesize orientation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    orientation = [UIApplication sharedApplication].statusBarOrientation;
    [super viewDidLoad];
    [self initArr];
    [self initFrame];
    //请求数据
    [self requestData];
    //设置scrollview
    [self settingScrollView];
    [self.view addSubview:self.scrollView];
    [self loadTapGestureRecognize];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self addSliderToolbar];
    self.topToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,PAGE_WIDTH,44)];
    [self initBackBtn];
    [self.view addSubview:topToolBar];
    isShowToolBar=true;
}

//初始化数组
-(void)initArr{
    imagesArr = [[NSMutableArray alloc] init];
    auctionNameArr = [[NSMutableArray alloc] init];
    lotArr = [[NSMutableArray alloc] init];
    evaluateCostArr = [[NSMutableArray alloc] init];
    metailArr = [[NSMutableArray alloc] init];
    closeCostArr = [[NSMutableArray alloc] init];
    auctionRemarkArr = [[NSMutableArray alloc] init];
}

//初始化frame
- (void)initFrame{
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        self.topToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,PAGE_HEIGHT,44)];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, PAGE_HEIGHT, PAGE_WIDTH)];
        self.buttomToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, PAGE_WIDTH-60, PAGE_HEIGHT, 44)];
        slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 10, PAGE_HEIGHT-15, 25)];
        self.auctionName = [[UILabel alloc]initWithFrame:CGRectMake(PAGE_HEIGHT/2-75, 0, 200, 20)];
        self.evaluateCost = [[UILabel alloc]initWithFrame:CGRectMake(PAGE_HEIGHT/2-150, 20, 400, 20)];
        
    }else if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        self.topToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,PAGE_WIDTH,44)];
        self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, PAGE_WIDTH, PAGE_HEIGHT)];
        self.buttomToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, PAGE_HEIGHT-60, PAGE_WIDTH, 44)];
        slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 10, PAGE_WIDTH-15, 25)];
        self.auctionName = [[UILabel alloc]initWithFrame:CGRectMake(PAGE_WIDTH/2-75, 0, 200, 20)];
        self.evaluateCost = [[UILabel alloc]initWithFrame:CGRectMake(PAGE_WIDTH/2-150, 20, 400, 20)];
    }
}

//初始化返回按钮
- (void)initBackBtn{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarStyleBlackOpaque target:self action:@selector(clickBack:)];
    [self.topToolBar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *speaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [speaceItem setWidth:500];
    
    UIBarButtonItem *showCompanyInfo = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    //信息item
    xinxiBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [xinxiBtn setFrame:CGRectMake(0, 0, 50, 40)];
    [xinxiBtn setImage:[UIImage imageNamed:@"auctionInfo_img.png"] forState:UIControlStateNormal];
    [xinxiBtn addTarget:self action:@selector(clickAuctionInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *xinxiItem = [[UIBarButtonItem alloc]initWithCustomView:xinxiBtn];
    [self.topToolBar setBarStyle:UIBarStyleDefault];
    [self.topToolBar setItems:[NSArray arrayWithObjects:backItem,speaceItem,showCompanyInfo,xinxiItem,nil]];
}

//初始化头部导航栏标题
- (void)initTitleLabel:(NSUInteger)index{
    self.auctionName.font = [UIFont systemFontOfSize:15];
    self.auctionName.backgroundColor = [UIColor clearColor];
    self.evaluateCost.textColor = [UIColor darkGrayColor];
    self.evaluateCost.font = [UIFont systemFontOfSize:13];
    self.evaluateCost.backgroundColor = [UIColor clearColor];
    [self.topToolBar addSubview:evaluateCost];
    [self.topToolBar addSubview:self.auctionName];
    [self updateTitleLabel:index];
}

- (void)clickAuctionInfo:(id)sender{
    NSUInteger index = fabs(self.scrollView.contentOffset.x/PAGE_WIDTH);
    self.auctionController=[[AuctionPopoverController alloc] initWithNibName:@"AuctionPopoverController" bundle:nil];
    self.auctionController.contentSizeForViewInPopover=CGSizeMake(400, 450);
    self.auctionPopover=[[UIPopoverController alloc] initWithContentViewController:self.auctionController];
    [self.auctionPopover presentPopoverFromRect:self.xinxiBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

//点击返回
-(void)clickBack:(id)sender{
    [self dismissModalViewControllerAnimated:YES];
}

//触摸点击
- (void)loadTapGestureRecognize{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleDoubleClick:)];
    singleTap.delegate = self;
    singleTap.numberOfTouchesRequired=1;
    singleTap.numberOfTapsRequired = 2;
    
    [self.scrollView addGestureRecognizer:singleTap];
}

//双击事件
-(void)singleDoubleClick:(UITapGestureRecognizer *)recognizer{
    isShowToolBar = !isShowToolBar;
    [self.topToolBar setHidden:isShowToolBar];
    [self.buttomToolBar setHidden:isShowToolBar];
}

//设置scrollview
- (void)settingScrollView{
    //初始化scrollview的界面 （坐标x，坐标y，宽度，高度）屏幕左上角为原点
    self.scrollView.pagingEnabled = YES;    //使用翻页属性
    self.scrollView.showsHorizontalScrollIndicator = NO;    //不实现水平滚动
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    self.scrollView.contentMode = NO;
    [self.scrollView setDelegate:self];
}

//添加工具栏
-(void)addSliderToolbar{
    self.buttomToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, PAGE_HEIGHT-60, 1024, 44)];
    slider.continuous = NO;
    slider.minimumValue=0;
    slider.value = 0;
    [self.buttomToolBar addSubview:guanzhuBtn];
    [slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.buttomToolBar addSubview:slider];
    [self.view addSubview:self.buttomToolBar];
}

//滑动slider改变图片
-(IBAction)sliderChange:(id)sender{
    NSUInteger page = (NSUInteger)roundf(slider.value);
    [self syncDownloadImage:page];
    [self updateTitleLabel:page];
    if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        [self.scrollView scrollRectToVisible:CGRectMake(page*PAGE_HEIGHT, 0, PAGE_HEIGHT, PAGE_WIDTH) animated:YES];
    }else if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        [self.scrollView scrollRectToVisible:CGRectMake(page*PAGE_WIDTH, 0, PAGE_WIDTH, PAGE_HEIGHT) animated:YES];
    }
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageControl:nil];
    [self setTopToolBar:nil];
    [self setTopRightBtn:nil];
    [self setBackBtn:nil];
    [self setAuctionName:nil];
    [self setEvaluateCost:nil];
    [self setLot:nil];
    [self setMaterialName:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

//请求数据
- (void)requestData{
    NSMutableDictionary *paramDic = [[NSMutableDictionary alloc] init];
    NSMutableDictionary *directory = [[NSMutableDictionary alloc]init];
    NSString *paramJson;
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:REQUEST_URL];
    [directory setValue:@"AppServiceImpl" forKey:@"className"];
    [directory setValue:@"queryAuctionByCatelog" forKey:@"methodName"];
    [paramDic setValue:self.specialCode forKey:@"specialCode"];
    [paramDic setValue:self.orderPa forKey:@"orderPa"];
    [paramDic setValue:self.auctionSort forKey:@"sort"];
    [directory setValue:paramDic forKey:@"parameter"];
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
        [SVProgressHUD showWithStatus:@"加载中,请稍候..."];//开始加载提示
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"服务器连接异常" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

#pragma mark Connection
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
    imageDictory = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
    if (NULL != imageDictory) {
        imagesArr = [imageDictory valueForKey:@"imageName"];
        auctionNameArr = [imageDictory valueForKey:@"auctionName"];
        lotArr = [imageDictory valueForKey:@"lot"];
        evaluateCostArr = [imageDictory valueForKey:@"evaluateCost"];
        metailArr = [imageDictory valueForKey:@"materialName"];
        closeCostArr = [imageDictory valueForKey:@"closeCost"];
        auctionRemarkArr = [imageDictory valueForKey:@"auctionRemark"];
        dataNum = [imagesArr count];        //总数据个数
        pageNum = (dataNum+IMAGESCAN_PAGE_DATA-1)/IMAGESCAN_PAGE_DATA;  //总页数
        currPage = 1;
        if (orientation == UIDeviceOrientationPortrait||orientation == UIDeviceOrientationPortraitUpsideDown) {
            [self.scrollView setContentSize:CGSizeMake(PAGE_HEIGHT*[imagesArr count], PAGE_WIDTH)];   
        }else if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
            [self.scrollView setContentSize:CGSizeMake(PAGE_WIDTH*[imagesArr count], PAGE_HEIGHT)];   
        }
        [self initTitleLabel:listIndex];
        slider.maximumValue = [imagesArr count]-1;
        slider.continuous = NO;
        slider.minimumValue=0;
        [self syncDownloadImage:listIndex];
        if (orientation == UIDeviceOrientationPortrait||orientation == UIDeviceOrientationPortraitUpsideDown) {
            [self.scrollView scrollRectToVisible:CGRectMake(listIndex*PAGE_HEIGHT, 0, PAGE_HEIGHT, PAGE_WIDTH) animated:YES];
        }else if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
            [self.scrollView scrollRectToVisible:CGRectMake(listIndex*PAGE_WIDTH, 0, PAGE_WIDTH, PAGE_HEIGHT) animated:YES];
        }
        self.slider.value = listIndex;
        [SVProgressHUD dismiss];//关闭加载提示
    }else{
        [SVProgressHUD dismissWithError:@"无拍品数据"];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error{
    [SVProgressHUD dismissWithError:@"连接异常"];
    NSLog(@"Connection Error : %@",error);
}

//更新标题信息
- (void)updateTitleLabel:(NSUInteger)index{
    NSString *closeCost,*metail;
    if ([imageDictory count]>0) {
        closeCost = [self.closeCostArr objectAtIndex:index];
        metail = [self.metailArr objectAtIndex:index];
        self.auctionName.text = [NSString stringWithFormat:@"%@  %@",[self.lotArr objectAtIndex:index],[self.auctionNameArr objectAtIndex:index]];
        self.evaluateCost.text = [NSString stringWithFormat:@"估价 (RMB) : %@   成交价 (RMB) : %@   材质: %@  ",[self.evaluateCostArr objectAtIndex:index],closeCost,metail];
    }
}

//屏幕旋转时调用
- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration{
    NSUInteger index = (NSUInteger)roundf(slider.value);
    if (toInterfaceOrientation == UIInterfaceOrientationPortrait|| toInterfaceOrientation ==UIInterfaceOrientationPortraitUpsideDown) {
        [self interfacePortrait:toInterfaceOrientation :index];
    }else if (toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft || toInterfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        [self interfaceLandscape:toInterfaceOrientation :index];
    }
}

//旋转竖屏算出坐标
- (void)interfacePortrait:(UIInterfaceOrientation)toInterfaceOrientation:(NSUInteger)index{
    [self.topToolBar setFrame:CGRectMake(0,0,PAGE_HEIGHT,44)];
    [self.scrollView setFrame:CGRectMake(0, 0, PAGE_HEIGHT, PAGE_WIDTH)];
    [self.buttomToolBar setFrame:CGRectMake(0, PAGE_WIDTH-60, PAGE_HEIGHT, 44)];
    [slider setFrame:CGRectMake(10, 10, PAGE_HEIGHT-15, 25)];
    [self.auctionName setFrame:CGRectMake(PAGE_HEIGHT/2-75, 0, 200, 20)];
    [self.evaluateCost setFrame:CGRectMake(PAGE_HEIGHT/2-150, 20, 400, 20)];
    self.scrollView.contentSize = CGSizeMake(PAGE_HEIGHT*[imagesArr count], PAGE_WIDTH);
    orientation = toInterfaceOrientation;
    [self syncDownloadImage:index];
    [self.scrollView scrollRectToVisible:CGRectMake(index*PAGE_HEIGHT, 0, PAGE_HEIGHT, PAGE_WIDTH) animated:YES];
}

//旋转横屏时算出坐标
- (void)interfaceLandscape:(UIInterfaceOrientation)toInterfaceOrientation:(NSUInteger)index{
    [self.topToolBar setFrame:CGRectMake(0,0,PAGE_WIDTH,44)];
    [self.scrollView setFrame:CGRectMake(0, 0, PAGE_WIDTH, PAGE_HEIGHT)];
    [self.buttomToolBar setFrame:CGRectMake(0, PAGE_HEIGHT-60, PAGE_WIDTH, 44)];
    [slider setFrame:CGRectMake(10, 10, PAGE_WIDTH-15, 25)];
    [self.auctionName setFrame:CGRectMake(PAGE_WIDTH/2-75, 0, 200, 20)];
    [self.evaluateCost setFrame:CGRectMake(PAGE_WIDTH/2-150, 20, 400, 20)];
    self.scrollView.contentSize = CGSizeMake(PAGE_WIDTH*[imagesArr count], PAGE_HEIGHT);
    orientation = toInterfaceOrientation;
    [self syncDownloadImage:index];
    [self.scrollView scrollRectToVisible:CGRectMake(index*PAGE_WIDTH, 0, PAGE_WIDTH, PAGE_HEIGHT) animated:YES];
}

//加载当前某个拍品数据
-(void)syncDownloadImage:(NSUInteger)index{
    //先删除已有imageview
    for (UIView *v in self.scrollView.subviews) {
        if ([v isKindOfClass:[UIImageView class]]) {
            [v removeFromSuperview];
        }
    }
    UIActivityIndicatorView *activityIndicator = [[UIActivityIndicatorView alloc] init];
    activityIndicator.center = self.scrollView.center;
    activityIndicator.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
    if (orientation == UIDeviceOrientationLandscapeLeft || orientation == UIDeviceOrientationLandscapeRight) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(index*PAGE_WIDTH, 0, PAGE_WIDTH, PAGE_HEIGHT)];
    }else if (orientation == UIDeviceOrientationPortrait || orientation == UIDeviceOrientationPortraitUpsideDown) {
        self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(index*PAGE_HEIGHT, 0, PAGE_HEIGHT, PAGE_WIDTH)];
    }
    [self.imageView addSubview:activityIndicator];
    [activityIndicator startAnimating];
    NSString *urlStr = [NSString stringWithFormat:AUCTION_DETAIL_URL,[[self.specialCode substringWithRange:NSMakeRange(0,6)]uppercaseString] , [imagesArr objectAtIndex:index]];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    [self.imageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage: [UIImage imageNamed:@"LOGO.png"] success:^(UIImage *image){
        [activityIndicator stopAnimating];
    } failure:^(NSError *error){
        NSLog(@"Image Error:%@",error);
    }];
    //手势放大缩小
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [self.imageView addGestureRecognizer:pinchRecognizer];
    [self.scrollView addSubview:self.imageView];
}

//缩放
- (void)scale:(id)sender{    
    [self.view bringSubviewToFront:[(UIPinchGestureRecognizer *)sender view]];
    //当手指离开屏幕时，将lastScale设置为1.0
    if ([(UIPinchGestureRecognizer *)sender state] == UIGestureRecognizerStateEnded) {
        lastScal = 1.0;
        return;
    }
    CGFloat sa = 1.0-(lastScal-[(UIPinchGestureRecognizer *)sender scale]);
    CGAffineTransform currentTransform = [(UIPinchGestureRecognizer *)sender view].transform;
    CGAffineTransform newTransform = CGAffineTransformScale(currentTransform, sa, sa);
    [[(UIPinchGestureRecognizer *)sender view] setTransform:newTransform];
    lastScal = [(UIPinchGestureRecognizer *)sender scale];
}

- (void)didReceiveMemoryWarning{
    [imagesArr removeAllObjects];
    [auctionNameArr removeAllObjects];
    [lotArr removeAllObjects];
    [evaluateCostArr removeAllObjects];
    [metailArr removeAllObjects];
    [closeCostArr removeAllObjects];
    [auctionRemarkArr removeAllObjects];
}

#pragma scrollview
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

//滑杆拖动事件
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{    
    NSUInteger index;
    if (orientation == UIInterfaceOrientationPortrait || orientation == UIInterfaceOrientationPortraitUpsideDown) {
        index = fabs(self.scrollView.contentOffset.x/PAGE_HEIGHT);
    }else if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        index = fabs(self.scrollView.contentOffset.x/PAGE_WIDTH);
    }
    
    self.slider.value = index;
    [self syncDownloadImage:index];
    [self updateTitleLabel:index];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}

@end
