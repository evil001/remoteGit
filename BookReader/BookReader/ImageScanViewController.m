//
//  ImageScanViewController.m
//  BookReader
//
//  Created by 晓军 唐 on 13-1-24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ImageScanViewController.h"
#import "UIImageView+WebCache.h"
#import "Utils.h"

@interface ImageScanViewController ()

@end

@implementation ImageScanViewController
@synthesize scrollView;
@synthesize pageControl;
@synthesize imagesArr;
@synthesize specialCode;
@synthesize pageNum,dataNum,currPage;
@synthesize currArr;

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
    self.scrollView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 1024, 768)];
    //设置scrollview画布得大小，此设置为三页得宽度，240得高度用来实现三页照片得转换
    [self.scrollView setContentSize:CGSizeMake(1024*[imagesArr count], 768)];
    self.scrollView.pagingEnabled = YES;    //使用翻页属性
    self.scrollView.showsHorizontalScrollIndicator = NO;    //不实现水平滚动
    [self.scrollView setDelegate:self];
    
    UIImageView *imageView;
    for (int i =0; i<[self.imagesArr count]; i++) {
        if (i<=currPage*IMAGESCAN_PAGE_DATA) {
            imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*1024, 0, 1024, 768)];
                   NSString *urlStr = [NSString stringWithFormat:@"http://new.hosane.com/hosane/upload/pic%@/big/%@",[[self.specialCode substringWithRange:NSMakeRange(0,6)]uppercaseString] , [imagesArr objectAtIndex:i]];
                    [imageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                    //设置图片为自适应
                    imageView.contentMode=UIViewContentModeScaleAspectFit;
                    [self.scrollView addSubview:imageView];  
        }
    }
    
    [self.view addSubview:self.scrollView];
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
    UIImageView *imageView;
    if (currPage<=pageNum) {
        for (int i =currPage*IMAGESCAN_PAGE_DATA; i<dataNum; i++) {
            if (i<=currPage*IMAGESCAN_PAGE_DATA+IMAGESCAN_PAGE_DATA) {
                imageView = [[UIImageView alloc]initWithFrame:CGRectMake(i*1024, 0, 1024, 768)];
                NSString *urlStr = [NSString stringWithFormat:@"http://new.hosane.com/hosane/upload/pic%@/big/%@",[[self.specialCode substringWithRange:NSMakeRange(0,6)]uppercaseString] , [imagesArr objectAtIndex:i]];
                [imageView setImageWithURL:[NSURL URLWithString:urlStr] placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
                //设置图片为自适应
                imageView.contentMode=UIViewContentModeScaleAspectFit;
                [self.scrollView addSubview:imageView];  
            }
            if (i==currPage*IMAGESCAN_PAGE_DATA+IMAGESCAN_PAGE_DATA) {
                currPage=currPage+1;
            }
        }
    }
     
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView{
}

- (void)scrollViewDidScrollToTop:(UIScrollView *)scrollView{
}

- (void)scrollViewWillBeginDecelerating:(UIScrollView *)scrollView{
    NSLog(@"scrollViewWillBeginDecelerating==========");
}

- (IBAction)changeImage:(id)sender {
}
@end
