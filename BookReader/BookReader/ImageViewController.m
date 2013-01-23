//
//  ImageViewController.m
//  BookReader
//
//  Created by 晓军 唐 on 13-1-8.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ImageViewController.h"
#import "ViewController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#define REQUEST_URL @"http://127.0.0.1:9091/?parmeter="
@implementation ImageViewController
@synthesize imageUrl;
@synthesize imagesArr_index;
@synthesize dataSource;
@synthesize slider;

- (id)init:(NSString *)params{
    imageUrl = params;
    self = [super init];
    if (self) {
        [self loadData];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder{
        NSLog(@"==========initWithCoder");
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self loadData];
            }
    return self;
}

-(void) loadData{

//    images = [[NSArray alloc] initWithObjects:
//              [UIImage imageNamed:@"p12121.jpg"],
//              [UIImage imageNamed:@"p12122.jpg"],
//              [UIImage imageNamed:@"s12121.jpg"],
//              [UIImage imageNamed:@"t12063.jpg"],
//              [UIImage imageNamed:@"t12121.jpg"],
//              [UIImage imageNamed:@"w12121.jpg"],
//              [UIImage imageNamed:@"w12122.jpg"],
//              [UIImage imageNamed:@"x12121.jpg"],
//              [UIImage imageNamed:@"a12121.jpg"],
//              [UIImage imageNamed:@"b12122.jpg"],
//              [UIImage imageNamed:@"b12123.jpg"],
//              [UIImage imageNamed:@"c12121.jpg"],
//              [UIImage imageNamed:@"c12122.jpg"],
//              [UIImage imageNamed:@"d12121.jpg"],
//              [UIImage imageNamed:@"d12122.jpg"],
//              [UIImage imageNamed:@"g12121.jpg"],
//              nil];
    
    [self requestData];
}

- (void)viewDidLoad{
    [super viewDidLoad];
    UIToolbar *toolBar = [[UIToolbar alloc]initWithFrame:CGRectMake(0, 660, 1010, 44)];
    slider=[[UISlider alloc] initWithFrame:CGRectMake(12, 10, 974, 25)];
    slider.continuous = NO;
    slider.minimumValue=0;
    slider.maximumValue=[images count];
    slider.value=0;
    [slider addTarget:self action:@selector(sliderChange:) forControlEvents:UIControlEventValueChanged];
    [toolBar addSubview:slider];
    [self.view addSubview:toolBar];
}

- (IBAction)sliderChange:(id)sender{
    NSLog(@"slider.value=%f",slider.value);
    int pageNum = (int)roundf(slider.value);
    [self changeCurrIndex:pageNum];
}

-(void) turnToPage {
    int pageNum = (int)roundf(slider.value);
    NSLog(@"%i=======",pageNum);
    [self changeCurrIndex:pageNum];
}

- (void)requestData{
    NSString *resultTemp = [[NSString alloc] initWithString:imageUrl];
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
    NSArray *imageUrl = [imageDictory valueForKey:@"imageName"];
    images = [[NSArray alloc] initWithArray:imageUrl];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
        return YES;
    }
    return NO;
}

#pragma mark - LeavesViewDataSource methods
- (NSUInteger) numberOfPagesInLeavesView:(LeavesView *)leavesView{
    return images.count;
}

- (void) renderPageAtIndex:(NSUInteger)index inContext:(CGContextRef)ctx {
    [super self];
    NSString *urlStr = [NSString stringWithFormat:@"http://new.hosane.com/hosane/upload/pic%@/big/%@",[[imageUrl substringWithRange:NSMakeRange(0,6)]uppercaseString] , [images objectAtIndex:index]];
    NSLog(@"===========%i",index);
    UIImage *image = [self newUIImageWithURLString:urlStr];
    CGRect imageRect = CGRectMake(0, 40, image.size.width, image.size.height);
    CGAffineTransform transform = aspectFit(imageRect, CGContextGetClipBoundingBox(ctx));
    CGContextConcatCTM(ctx, transform);
    CGContextDrawImage(ctx, imageRect, [image CGImage]);
}

//回退事件
- (void)btnBack{
    [self changeCurrIndex:4];
//    ViewController *viewController = [[ViewController alloc] init];
//    [viewController setModalTransitionStyle:UIModalTransitionStyleCrossDissolve];
//    [self presentModalViewController:viewController animated:YES];
}

- (UIImage *)newUIImageWithURLString:(NSString *)urlStr{
    return [[UIImage alloc]initWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:urlStr]]];
}

@end
