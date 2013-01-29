//
//  ImageScanViewController.h
//  BookReader
//
//  Created by 晓军 唐 on 13-1-24.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SDWebImageDownloader.h"

@interface ImageScanViewController : UIViewController<UIScrollViewDelegate,UIGestureRecognizerDelegate>{
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
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@property (nonatomic) CGFloat lastScal;

@property (strong, nonatomic) UIToolbar *buttomToolBar;
@property (strong, nonatomic) UIToolbar *topToolBar;

@property BOOL isShowToolBar;
@end
