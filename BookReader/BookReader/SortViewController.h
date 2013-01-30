//
//  SortViewController.h
//  BookReader
//  拍品排序View
//  Created by Dwen on 13-1-29.
//
//

#import <UIKit/UIKit.h>
#import "RequestVO.h"

//协议
@protocol sortDataDelegate<NSObject>
@required
- (void) loadDataShow : (RequestVO *)requestParams;
@end

@interface SortViewController : UITableViewController

@property (strong,nonatomic) id<sortDataDelegate> delegate;
@property (strong, nonatomic) UIPopoverController *popover;
@property(strong,nonatomic) NSMutableArray *sortArry;
//排序字符串
@property(strong,nonatomic) NSString *sortStr;
//目录号
@property (strong,nonatomic) NSString *specialCode;
@end
