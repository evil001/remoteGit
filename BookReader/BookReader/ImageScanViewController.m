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
#import "Utils.h"

@interface ImageScanViewController ()
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) NSMutableArray *titleArr;
@property (strong, nonatomic) UIButton *backBtn;
@property (strong, nonatomic) UIButton *guanzhuBtn;
@end

@implementation ImageScanViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize imagesArr;
@synthesize specialCode;
@synthesize pageNum,currPage;
@synthesize slider;
@synthesize activityIndicatorView;
@synthesize lastScal;
@synthesize imageView;
@synthesize buttomToolBar;
@synthesize topToolBar;
@synthesize isShowToolBar;
@synthesize titleLabel;
@synthesize titleArr;
@synthesize backBtn;
@synthesize guanzhuBtn;

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
    [self requestData];
    [self settingScrollView];
    self.titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(PAGE_WIDTH/2-140, 44/2-18, 400, 44)];
    [self.titleLabel setBackgroundColor:[UIColor clearColor]];
    self.titleLabel.numberOfLines = 2;
    self.titleLabel.font = [UIFont systemFontOfSize:14];
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.titleArr objectAtIndex:0]];
    for (int i =0; i<[self.imagesArr count]; i++) {
        [self syncDownloadImage:i];
    }
    [self.view addSubview:self.scrollView];
    [self loadTapGestureRecognize];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    [self addSliderToolbar];
    self.topToolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0,0,PAGE_WIDTH,44)];
    self.backBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect btnRect = CGRectMake(10, 44/2-15, 50, 30);
    [self.backBtn setFrame:btnRect];
    [self.backBtn setBackgroundColor:[UIColor clearColor]];
    [self.backBtn setTitle:@"返回" forState:UIControlStateNormal];
    [self.backBtn addTarget:self action:@selector(clickBack:) forControlEvents:UIControlEventTouchUpInside];
    [self.topToolBar addSubview:self.backBtn];
    [self.topToolBar addSubview:self.titleLabel];
    [self.view addSubview:topToolBar];
    isShowToolBar=true;
}

-(void)clickBack:(id)sender{
    NSLog(@"click back");
    ViewController *viewControl = [[ViewController alloc]init];
    [self setModalTransitionStyle:UIModalTransitionStyleCoverVertical];
    [self presentModalViewController:viewControl animated:YES];
//    [self.navigationController pushViewController:viewControl animated:YES];
}

- (void)loadTapGestureRecognize{
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(singleDoubleClick:)];
    singleTap.delegate = self;
    singleTap.numberOfTouchesRequired=1;
    singleTap.numberOfTapsRequired = 2;

    [self.scrollView addGestureRecognizer:singleTap];
}

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
    slider = [[UISlider alloc]initWithFrame:CGRectMake(100, 10, 900, 25)];
    guanzhuBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, 10, 50, 30)];
    [guanzhuBtn setTitle:@"关注" forState:UIControlStateNormal];
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
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.titleArr objectAtIndex:page]];
    [self.scrollView scrollRectToVisible:CGRectMake(page*PAGE_WIDTH, 0, PAGE_WIDTH, PAGE_HEIGHT) animated:YES];
    [self.activityIndicatorView stopAnimating];
}

- (void)viewDidUnload
{
    [self setScrollView:nil];
    [self setPageControl:nil];
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return YES;
    }
    return NO;
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
    titleArr = [[NSMutableArray alloc]initWithArray:[imageDictory valueForKey:@"auctionName"]];
    dataNum = [imagesArr count];        //总数据个数
    pageNum = (dataNum+IMAGESCAN_PAGE_DATA-1)/IMAGESCAN_PAGE_DATA;  //总页数
    currPage = 1;
}

#pragma scrollview

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    self.slider.value = fabs(self.scrollView.contentOffset.x/PAGE_WIDTH);
    self.titleLabel.text = [NSString stringWithFormat:@"%@",[self.titleArr objectAtIndex:self.slider.value]];
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
    NSString *urlStr = [NSString stringWithFormat:AUCTION_URL,[[self.specialCode substringWithRange:NSMakeRange(0,6)]uppercaseString] , [imagesArr objectAtIndex:index]];
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
