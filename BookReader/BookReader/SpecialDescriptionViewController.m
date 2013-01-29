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
@synthesize txtView;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        txtView = [[UITextView alloc] initWithFrame:self.view.frame];
        txtView.textColor = [UIColor blackColor];
        txtView.delegate = self;
        txtView.editable = NO;
        [self.view addSubview:txtView];
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
    [self setTxtView:nil];
    [super viewDidUnload];
}
@end
