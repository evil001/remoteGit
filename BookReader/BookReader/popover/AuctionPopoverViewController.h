//
//  AuctionPopoverViewController.h
//  BookReader
//
//  Created by wangyuxin on 13-1-29.
//
//

#import <UIKit/UIKit.h>

@interface AuctionPopoverViewController : UIViewController
@property (strong, nonatomic) IBOutlet UILabel *lot;
@property (strong, nonatomic) IBOutlet UILabel *auctionName;
@property (strong, nonatomic) IBOutlet UILabel *auctionFormat;
@property (strong, nonatomic) IBOutlet UILabel *size;
@property (strong, nonatomic) IBOutlet UILabel *material;
@property (strong, nonatomic) IBOutlet UIView *evaluteCost;
@property (strong, nonatomic) IBOutlet UILabel *closeCost;
@property (strong, nonatomic) IBOutlet UILabel *description;

@end
