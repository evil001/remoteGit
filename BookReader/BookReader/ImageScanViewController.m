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

@interface ImageScanViewController ()
//@property (strong, nonatomic) UILabel *titleLabel;

@property (strong, nonatomic) NSMutableArray *auctionNameArr,*lotArr,*evaluateCostArr,*metailArr;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBtn;
@property (strong, nonatomic) IBOutlet UILabel *materialName;
@property (strong, nonatomic) UIButton *guanzhuBtn;
@property (strong, nonatomic) UIButton *xinxiBtn;
@end

@implementation ImageScanViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize imagesArr,auctionNameArr,lotArr,evaluateCostArr,metailArr;
@synthesize specialCode;
@synthesize pageNum,currPage,listIndex;
@synthesize slider;
@synthesize activityIndicatorView;
@synthesize lastScal;
@synthesize imageView;
@synthesize buttomToolBar;
@synthesize topToolBar;
@synthesize topRightBtn;
@synthesize isShowToolBar;
@synthesize auctionName;
@synthesize evaluateCost;
@synthesize lot;
//@synthesize titleLabel;
@synthesize xinxiBtn;
@synthesize materialName;
@synthesize guanzhuBtn;
@synthesize auctionSort;
@synthesize auctionController;
@synthesize auctionPopover;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //请求数据
    [self requestData];
    //设置scrollview
    [self settingScrollView];
    //    [self initTitleLabel];
    for (int i =0; i<[self.imagesArr count]; i++) {
        [self syncDownloadImage:i];
    }
    [self.scrollView scrollRectToVisible:CGRectMake(listIndex*PAGE_WIDTH, 0, PAGE_WIDTH, PAGE_HEIGHT) animated:YES];
    [self.view addSubview:self.scrollView];
    [self loadTapGestureRecognize];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self addSliderToolbar];
    self.topToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,PAGE_WIDTH,44)];
    [self initTitleLabel];
    [self initBackBtn];
    [self.view addSubview:topToolBar];
    isShowToolBar=true;
}

//初始化返回按钮
- (void)initBackBtn{
    UIBarButtonItem *backItem = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarStyleBlackOpaque target:self action:@selector(clickBack:)];
    [self.topToolBar setBarStyle:UIBarStyleDefault];
    
    UIBarButtonItem *speaceItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    [speaceItem setWidth:500];
    
    UIBarButtonItem *showCompanyInfo = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemAction target:self action:nil];
    //信息item
    xinxiBtn = [UIButton buttonWithType:UIButtonTypeInfoLight];
    [xinxiBtn addTarget:self action:@selector(clickAuctionInfo:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *xinxiItem = [[UIBarButtonItem alloc]initWithCustomView:xinxiBtn];
    [self.topToolBar setBarStyle:UIBarStyleDefault];
    [self.topToolBar setItems:[NSArray arrayWithObjects:backItem,speaceItem,showCompanyInfo,xinxiItem,nil]];
    
}

//初始化头部导航栏标题
- (void)initTitleLabel{
    self.auctionName = [[UILabel alloc]initWithFrame:CGRectMake(510, 1, 200, 20)];
    self.auctionName.text = [NSString stringWithFormat:@"%@",[self.auctionNameArr objectAtIndex:0]];
    self.auctionName.font = [UIFont systemFontOfSize:15];
    self.auctionName.backgroundColor = [UIColor clearColor];
    self.lot = [[UILabel alloc]initWithFrame:CGRectMake(441, 1, 100, 20)];
    self.lot.text = [NSString stringWithFormat:@"%@",[self.lotArr objectAtIndex:0]];
    self.lot.font = [UIFont systemFontOfSize:15];
    self.lot.textAlignment = UITextAlignmentCenter;
    self.lot.backgroundColor = [UIColor clearColor];
    self.evaluateCost = [[UILabel alloc]initWithFrame:CGRectMake(441, 20, 150, 20)];
    self.evaluateCost.textColor = [UIColor darkGrayColor];
    self.evaluateCost.text = [NSString stringWithFormat:@"估价 (RMB) : %@",[self.evaluateCostArr objectAtIndex:0]];
    self.evaluateCost.font = [UIFont systemFontOfSize:13];
    self.evaluateCost.backgroundColor = [UIColor clearColor];
    self.materialName = [[UILabel alloc] initWithFrame:CGRectMake(600, 20, 200, 20)];
    self.materialName.textColor = [UIColor darkGrayColor];
    self.materialName.text = [NSString stringWithFormat:@"材质 : %@",[self.metailArr objectAtIndex:0]];
    self.materialName.font = [UIFont systemFontOfSize:13];
    self.materialName.backgroundColor = [UIColor clearColor];
    [self.topToolBar addSubview:materialName];
    [self.topToolBar addSubview:evaluateCost];
    [self.topToolBar addSubview:self.lot];
    [self.topToolBar addSubview:self.auctionName];
}

- (void)clickAuctionInfo:(id)sender{
    NSUInteger index = fabs(self.scrollView.contentOffset.x/PAGE_WIDTH);
    self.auctionController=[[AuctionPopoverController alloc] initWithNibName:@"AuctionPopoverController" bundle:nil];
    self.auctionPopover=[[UIPopoverController alloc] initWithContentViewController:self.auctionController];
    self.auctionController.contentSizeForViewInPopover=CGSizeMake(400, 600);
    [self.auctionPopover presentPopoverFromRect:self.xinxiBtn.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionUp animated:YES];
}

-(void)clickBack:(id)sender{
    NSLog(@"click back");
    //    CatalogViewController *catalogView = [[CatalogViewController alloc]initWithNibName:@"CatalogViewController" bundle:nil];
//    ViewController *v = [[ViewController alloc]init];
//    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
//    [self presentModalViewController:v animated:YES];
    [self dismissModalViewControllerAnimated:YES];
    //    [self.navigationController pushViewController:catalogView animated:YES];
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

//设置动画加载
- (void)initActivityView{
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(PAGE_WIDTH/2, PAGE_HEIGHT/2, 50, 50)];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.activityIndicatorView];
}

//设置scrollview
- (void)settingScrollView{
    //初始化scrollview的界面 （坐标x，坐标y，宽度，高度）屏幕左上角为原点
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, PAGE_WIDTH, PAGE_HEIGHT)];
    //设置scrollview画布得大小，此设置为三页得宽度，240得高度用来实现三页照片得转换
    [self.scrollView setContentSize:CGSizeMake(PAGE_WIDTH*[imagesArr count], PAGE_HEIGHT)];
    self.scrollView.pagingEnabled = YES;    //使用翻页属性
    self.scrollView.showsHorizontalScrollIndicator = NO;    //不实现水平滚动
    [self.scrollView setBackgroundColor:[UIColor blackColor]];
    self.scrollView.contentMode = NO;
    [self.scrollView setDelegate:self];
}

//添加工具栏
-(void)addSliderToolbar{
    self.buttomToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, PAGE_HEIGHT-60, 1024, 44)];
    slider = [[UISlider alloc]initWithFrame:CGRectMake(10, 10, PAGE_WIDTH-15, 25)];
    //    guanzhuBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
    //    [guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
    slider.continuous = NO;
    slider.minimumValue=0;
    slider.maximumValue = [imagesArr count]-1;
    slider.value = 0;
    [self.buttomToolBar addSubview:guanzhuBtn];
    [slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [self.buttomToolBar addSubview:slider];
    [self.view addSubview:self.buttomToolBar];
}

//滑动slider改变图片
-(IBAction)sliderChange:(id)sender{
    [self.activityIndicatorView startAnimating];
    NSUInteger page = (NSUInteger)roundf(slider.value);
    //    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.titleArr objectAtIndex:page]];
    [self.scrollView scrollRectToVisible:CGRectMake(page*PAGE_WIDTH, 0, PAGE_WIDTH, PAGE_HEIGHT) animated:YES];
    [self.activityIndicatorView stopAnimating];
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
    return (interfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)requestData{
    NSString *resultTemp = [[NSString alloc] initWithString:specialCode];
    NSMutableDictionary *directory = [[NSMutableDictionary alloc]init];
    NSString *paramJson;
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:REQUEST_URL];
    [directory setValue:@"AppServiceImpl" forKey:@"className"];
    [directory setValue:@"queryAuctionByCatelog" forKey:@"methodName"];
    [directory setValue:[[resultTemp substringWithRange:NSMakeRange(0,6)]uppercaseString] forKey:@"parameter"];
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
    NSHTTPURLResponse *response;
    NSError *error ;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];    
    NSDictionary *imageDictory = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    imagesArr = [[NSMutableArray alloc]initWithArray:[imageDictory valueForKey:@"imageName"]];
    self.auctionNameArr = [[NSMutableArray alloc]initWithArray:[imageDictory valueForKey:@"auctionName"]];
    self.lotArr = [[NSMutableArray alloc]initWithArray:[imageDictory valueForKey:@"lot"]];
    self.evaluateCostArr = [[NSMutableArray alloc]initWithArray:[imageDictory valueForKey:@"evaluateCost"]];
    self.metailArr = [[NSMutableArray alloc]initWithArray:[imageDictory valueForKey:@"materialName"]];
    dataNum = [imagesArr count];        //总数据个数
    pageNum = (dataNum+IMAGESCAN_PAGE_DATA-1)/IMAGESCAN_PAGE_DATA;  //总页数
    currPage = 1;
}

#pragma scrollview

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.slider.value = fabs(self.scrollView.contentOffset.x/PAGE_WIDTH);
    //    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.titleArr objectAtIndex:self.slider.value]];
}

-(void)scrollviewPage{
    for (int i =currPage*IMAGESCAN_PAGE_DATA; i<currPage*IMAGESCAN_PAGE_DATA+IMAGESCAN_PAGE_DATA; i++) {
        if (i<=currPage*IMAGESCAN_PAGE_DATA+IMAGESCAN_PAGE_DATA) {
            [self syncDownloadImage:i];
        }
        if (i==currPage*IMAGESCAN_PAGE_DATA+IMAGESCAN_PAGE_DATA) {
            currPage=currPage+1;
        }
    }
}

-(void)syncDownloadImage:(NSUInteger)index{
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(index*PAGE_WIDTH, 0, PAGE_WIDTH, PAGE_HEIGHT)];
    NSString *urlStr = [NSString stringWithFormat:AUCTION_DETAIL_URL,[[self.specialCode substringWithRange:NSMakeRange(0,6)]uppercaseString] , [imagesArr objectAtIndex:index]];
    [imageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    imageView.userInteractionEnabled = YES;
    //设置图片为自适应
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    
    //手势放大缩小
    UIPinchGestureRecognizer *pinchRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(scale:)];
    [pinchRecognizer setDelegate:self];
    [imageView addGestureRecognizer:pinchRecognizer];
    [self.scrollView addSubview:imageView];
    
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

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    
}

@end
