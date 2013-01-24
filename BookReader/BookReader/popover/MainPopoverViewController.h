//
//  MainPopoverViewController.h
//  BookReader
//
//  Created by wangyuxin on 13-1-24.
//
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@interface MainPopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (strong, nonatomic) IBOutlet UITableView *seasonTableView;
@property (strong, nonatomic) IBOutlet UITableView *saleTableView;

@property (strong,nonatomic) NSArray *seasonArray;
@property (strong,nonatomic) NSArray *saleArray;
@end
