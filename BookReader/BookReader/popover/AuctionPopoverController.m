//
//  AuctionPopoverController.m
//  BookReader
//
//  Created by wangyuxin on 13-1-29.
//
//

#import "AuctionPopoverController.h"

@interface AuctionPopoverController ()

@end

@implementation AuctionPopoverController
@synthesize specialCode;
@synthesize lot;
@synthesize auctionDescription;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.description.text=self.auctionDescription;
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLot:nil];
    [self setDescription:nil];
    [super viewDidUnload];
}
@end
