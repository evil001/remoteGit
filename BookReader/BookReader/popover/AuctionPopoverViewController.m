//
//  AuctionPopoverViewController.m
//  BookReader
//
//  Created by wangyuxin on 13-1-29.
//
//

#import "AuctionPopoverViewController.h"

@interface AuctionPopoverViewController ()

@end

@implementation AuctionPopoverViewController



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
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setLot:nil];
    [self setAuctionName:nil];
    [self setAuctionFormat:nil];
    [self setSize:nil];
    [self setMaterial:nil];
    [self setEvaluteCost:nil];
    [self setCloseCost:nil];
    [self setDescription:nil];
    [super viewDidUnload];
}
@end
