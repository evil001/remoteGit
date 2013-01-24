//
//  MainPopoverViewController.h
//  BookReader
//
//  Created by wangyuxin on 13-1-24.
//
//

#import <UIKit/UIKit.h>
#import "ASIHTTPRequest.h"

@protocol PopViewControllerDelegate;

@interface MainPopoverViewController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property (weak) id <PopViewControllerDelegate> delegate;
@property (strong, nonatomic) IBOutlet UITableView *seasonTableView;
@property (strong,nonatomic) NSArray *seasonArray;
@property (nonatomic,weak) UIPopoverController *popover;
@end


@protocol PopViewControllerDelegate <NSObject>
@required
- (void)dismissPop:(NSString *)value;

@end