//
//  SortViewController.h
//  BookReader
//  拍品排序View
//  Created by Dwen on 13-1-29.
//
//

#import <UIKit/UIKit.h>

@interface SortViewController : UITableViewController

@property (strong, nonatomic) UIPopoverController *popover;
@property(strong,nonatomic) NSMutableArray *sortArry;
//排序字符串
@property(strong,nonatomic) NSString *sortStr;
//目录号
@property (strong,nonatomic) NSString *specialCode;
@end
