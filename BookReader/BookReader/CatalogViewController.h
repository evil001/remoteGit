//
//  CatalogViewController.h
//  IpadLisShow
//
//  Created by Dwen on 13-1-21.
//  Copyright (c) 2013年 Dwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "CatalogView.h"
#import "RequestVO.h"
#import "Utils.h"

@interface CatalogViewController : UIViewController<UIScrollViewDelegate,UINavigationBarDelegate,NSURLConnectionDataDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *pageView;
@property (strong,nonatomic) NSMutableArray *commImgArr;
//拍品图
@property (strong,nonatomic) NSMutableArray *imgArr;
//拍品Lot号
@property (strong,nonatomic) NSMutableArray *lotArr;
@property (strong,nonatomic) NSMutableArray *commLotArr;
@property (weak, nonatomic) IBOutlet UINavigationBar *navigationBar;
@property (strong,nonatomic) RequestVO *requestVO;
@property (strong,nonatomic) NSMutableData *receivedData;
//当前页
@property (nonatomic) NSInteger currentPage;
//总记录数
@property (nonatomic) NSInteger totalNum;
//拍品总页数
@property (nonatomic) NSInteger totalPage;
//每次加载页数
@property (nonatomic) NSInteger loadPage;
//滑动页数
@property (nonatomic) NSInteger pageNum;
//目录号
@property (strong,nonatomic) NSString *specialCode;
@property (strong,nonatomic) NSString *imageUrl;
//拖动
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic) NSInteger sliderValue;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segBtn;

//初始化nib
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil : (NSString *)imgUrl;
//改变seg
- (IBAction)changeSeg:(id)sender;

@end
