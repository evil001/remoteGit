//
//  CatalogViewController.h
//  IpadLisShow
//  拍品列表
//  Created by Dwen on 13-1-21.
//  Copyright (c) 2013年 Dwen. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIImageView+WebCache.h"
#import "CatalogView.h"
#import "RequestVO.h"
#import "Utils.h"
#import "SpecialDescriptionViewController.h"
#import "SortViewController.h"

@interface CatalogViewController : UIViewController<UIScrollViewDelegate,UINavigationBarDelegate,NSURLConnectionDataDelegate,sortDataDelegate>
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) UIView *pageView;
//拍品图
@property (strong,nonatomic) NSMutableArray *imgArr;
@property (strong,nonatomic) NSMutableArray *commImgArr;
//拍品Lot号
@property (strong,nonatomic) NSMutableArray *lotArr;
@property (strong,nonatomic) NSMutableArray *commLotArr;
//拍品成交价
@property (strong,nonatomic) NSMutableArray *closeClostArr;
@property (strong,nonatomic) NSMutableArray *commCloseClostArr;
//拍品名称
@property (strong,nonatomic) NSMutableArray *displayMsgArr;
@property (strong,nonatomic) NSMutableArray *commdisplayMsgArr;
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
@property (strong,nonatomic) NSString *orderPa;
@property (strong,nonatomic) NSString *sort;
@property (strong,nonatomic) NSString *imageUrl;
//专场名称
@property (strong,nonatomic) NSString *specialName;
@property (strong,nonatomic) NSString *specialAddress;
@property (strong,nonatomic) NSString *specialAuctionTime;
@property (strong,nonatomic) NSString *specialPreview;
@property (strong,nonatomic) NSString *specialRemark;
//拖动
@property (strong, nonatomic) IBOutlet UISlider *slider;
@property (nonatomic) NSInteger sliderValue;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segBtn;
@property (strong, nonatomic) UIPopoverController *popover;
@property (strong, nonatomic) UIBarButtonItem *firstBtn;
@property (strong, nonatomic) SpecialDescriptionViewController *sdVC;
@property (strong, nonatomic) SortViewController *sortVC;
@property (strong, nonatomic) IBOutlet UIButton *sortBtn;
//是否显示专场简介
@property (nonatomic) BOOL isShowSpecial;

//初始化nib
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil : (NSString *)imgUrl;
//改变seg
- (IBAction)changeSeg:(id)sender;
//排序
- (IBAction)sortAction:(id)sender;

- (void) initRequestParam;
- (void) initRequestData : (RequestVO *) requestParam;

@end
