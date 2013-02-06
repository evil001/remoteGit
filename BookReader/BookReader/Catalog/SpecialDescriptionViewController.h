//
//  SpecialDescriptionViewController.h
//  BookReader
//  专场描述简介
//  Created by Dwen on 13-1-29.
//
//

#import <UIKit/UIKit.h>

@interface SpecialDescriptionViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UITextView *previewView;
@property (strong, nonatomic) IBOutlet UITextView *auctionTimeView;
@property (strong, nonatomic) IBOutlet UITextView *addressView;
@property (strong, nonatomic) IBOutlet UITextView *remarkView;

@end
