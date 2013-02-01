//
//  ImageScanViewController.h
//  BookReader
//  拍品详细大图页
//  Created by 晓军 唐 on 13-1-24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageDownloader.h"
#import "AuctionPopoverController.h"
#import "ScanView.h"

@interface ImageScanViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate,NSURLConnectionDataDelegate>{
    UIScrollView *scrollView;
    NSString *specialCode;      
    
    NSUInteger pageNum;
    NSUInteger dataNum;
    NSUInteger loadPageData;
    NSUInteger currPage;
    
    
}
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UIPageControl *pageControl;
@property (strong, nonatomic) IBOutlet UIImageView *imageView;
- (IBAction)changeImage:(id)sender;
@property (strong, nonatomic) NSMutableArray *imagesArr;
@property (strong, nonatomic) NSString *specialCode;
@property NSUInteger pageNum;       //总页数
@property NSUInteger currPage;      //当前页数
@property (strong,nonatomic) UISlider *slider;
@property (strong, nonatomic) NSMutableData *receivedData;

@property (nonatomic) CGFloat lastScal;

//顶部工具栏
@property (strong, nonatomic) UIToolbar *buttomToolBar;
//底部工具栏
@property (strong, nonatomic) IBOutlet UIToolbar *topToolBar;
@property (strong, nonatomic) UIButton *topRightBtn;
//列表页传得索引值
@property NSUInteger listIndex;

@property BOOL isShowToolBar;

@property (strong, nonatomic) IBOutlet UILabel *auctionName;
@property (strong, nonatomic) IBOutlet UILabel *evaluateCost;
@property (strong, nonatomic) IBOutlet UILabel *lot;
@property (strong, nonatomic) NSString *auctionSort;
@property (strong, nonatomic) NSString *orderPa;

@property (strong, nonatomic) UIPopoverController *auctionPopover;
@property (strong, nonatomic) AuctionPopoverController *auctionController;

@end
