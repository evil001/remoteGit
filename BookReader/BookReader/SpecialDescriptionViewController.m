//
//  SpecialDescriptionViewController.m
//  BookReader
//
//  Created by Dwen on 13-1-29.
//
//

#import "SpecialDescriptionViewController.h"

@interface SpecialDescriptionViewController ()

@end

@implementation SpecialDescriptionViewController
@synthesize scrollView;
@synthesize addressView;
@synthesize auctionTimeView;
@synthesize previewView;
@synthesize remarkView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        scrollView = [[UIScrollView alloc] initWithFrame:self.view.frame];
//        [scrollView setDelegate:self];
        scrollView.pagingEnabled = YES;
        [scrollView setScrollEnabled:YES];
        [scrollView setShowsHorizontalScrollIndicator:NO];
        [scrollView setShowsVerticalScrollIndicator:NO];
        [self.view addSubview:scrollView];
        
        previewView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 55)];
        previewView.editable = NO;
        previewView.scrollEnabled = NO;
        [scrollView addSubview:previewView];
        
        auctionTimeView = [[UITextView alloc] initWithFrame:CGRectMake(0, 55, self.view.frame.size.width, 55)];
        auctionTimeView.editable = NO;
        auctionTimeView.scrollEnabled = NO;
        [scrollView addSubview:auctionTimeView];
        
        addressView = [[UITextView alloc] initWithFrame:CGRectMake(0, 110, self.view.frame.size.width, 55)];
        addressView.editable = NO;
        addressView.scrollEnabled = NO;
        [scrollView addSubview:addressView];
        
        remarkView = [[UITextView alloc] initWithFrame:CGRectMake(0, 165, self.view.frame.size.width, 55)];
        remarkView.editable = NO;
        remarkView.scrollEnabled = NO;
        [scrollView addSubview:remarkView];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidUnload {
    [self setScrollView:nil];
    [super viewDidUnload];
}
@end
