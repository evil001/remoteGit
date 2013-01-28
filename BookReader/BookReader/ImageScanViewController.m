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
#import "Utils.h"

@interface ImageScanViewController ()

@end

@implementation ImageScanViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize imagesArr;
@synthesize specialCode;
@synthesize pageNum,currPage;
@synthesize currArr;
@synthesize slider;
@synthesize activityIndicatorView;
@synthesize image;
@synthesize lastScal;
@synthesize imageView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self requestData];
    //初始化scrollview的界面 （坐标x，坐标y，宽度，高度）屏幕左上角为原点
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 660)];
    //设置scrollview画布得大小，此设置为三页得宽度，240得高度用来实现三页照片得转换
    [self.scrollView setContentSize:CGSizeMake(1024*[imagesArr count], 660)];
    self.scrollView.pagingEnabled = YES;    //使用翻页属性
    self.scrollView.showsHorizontalScrollIndicator = NO;    //不实现水平滚动
    self.scrollView.contentMode = NO;
    [self.scrollView setDelegate:self];
    [self addSliderToolbar];
    self.image = [[UIImage alloc]init];
    for (int i =0; i<[self.imagesArr count]; i++) {
        if (i<=currPage*IMAGESCAN_PAGE_DATA) {
            [self syncDownloadImage:i];
        }
    }
    [self.view addSubview:pageControl];
    [self.view addSubview:self.scrollView];
    self.activityIndicatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(1024/2, 660/2, 50, 50)];
    self.activityIndicatorView.activityIndicatorViewStyle = UIActivityIndicatorViewStyleGray;
    [self.view addSubview:self.activityIndicatorView];
    pageControl = [[UIPageControl alloc]init];
    pageControl.numberOfPages = [imagesArr count];
    pageControl.currentPage = 0;
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)images {
    self.image = images;
    [self.activityIndicatorView stopAnimating];
}

- (void)pageTurn:(UIPageControl *)sender{
    CGSize viewSize = self.scrollView.frame.size;
    CGRect rect = CGRectMake(sender.currentPage*viewSize.width, 0, viewSize.width, viewSize.height);
    [self.scrollView scrollRectToVisible:rect animated:YES];
}

//添加工具栏
-(void)addSliderToolbar{
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 660, 1024, 44)];
    slider = [[UISlider alloc]initWithFrame:CGRectMake(12, 10, 974, 25)];
    slider.continuous = NO;
    slider.minimumValue=0;
    slider.maximumValue = [imagesArr count]-1;
    slider.value = 0;
    [slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [toolBar addSubview:slider];
    [self.view addSubview:toolBar];
}

//滑动slider改变图片
-(IBAction)sliderChange:(id)sender{
    [self.activityIndicatorView startAnimating];
    NSUInteger page = (NSUInteger)roundf(slider.value);
    [self syncDownloadImage:page];
    [self.scrollView scrollRectToVisible:CGRectMake(page*1024, 0, 1024, 660) animated:YES];
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
    //    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    //    NSLog(@"---------------%@",result);
    
    NSDictionary *imageDictory = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    imagesArr = [[NSMutableArray alloc]initWithArray:[imageDictory valueForKey:@"imageName"]];
    dataNum = [imagesArr count];        //总数据个数
    pageNum = (dataNum+IMAGESCAN_PAGE_DATA-1)/IMAGESCAN_PAGE_DATA;  //总页数
    currPage = 1;
}

#pragma scrollview

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
    if (currPage<=pageNum) {
        [self scrollviewPage];
    }
     
    self.slider.value = 20;
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
    imageView = [[UIImageView alloc]initWithFrame:CGRectMake(index*1024, 0, 1024, 768-44)];
    NSString *urlStr = [NSString stringWithFormat:@"http://new.hosane.com/hosane/upload/pic%@/big/%@",[[self.specialCode substringWithRange:NSMakeRange(0,6)]uppercaseString] , [imagesArr objectAtIndex:index]];
    [imageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    //设置图片为自适应
    imageView.contentMode=UIViewContentModeScaleAspectFit;
    imageView.userInteractionEnabled=YES;
    
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

- (IBAction)changeImage:(id)sender {
}
@end
