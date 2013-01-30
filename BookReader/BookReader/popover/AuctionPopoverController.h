//
//  AuctionPopoverController.h
//  BookReader
//
//  Created by wangyuxin on 13-1-29.
//
//

#import <UIKit/UIKit.h>

@interface AuctionPopoverController : UIViewController
@property (strong,nonatomic) NSString *specialCode;
@property (strong,nonatomic) NSString *lot;

@property (strong, nonatomic) IBOutlet UILabel *auctionLot;
@property (strong, nonatomic) IBOutlet UILabel *auctionName;
@property (strong, nonatomic) IBOutlet UILabel *description;
@end
