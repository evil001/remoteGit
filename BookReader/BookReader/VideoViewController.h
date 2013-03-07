//
//  VideoViewController.h
//  BookReader
//  视频专区
//  Created by Dwen on 13-3-6.
//
//

#import <UIKit/UIKit.h>
#import <MediaPlayer/MediaPlayer.h>
#import "CoverFlowView.h"

@interface VideoViewController : UIViewController<UIScrollViewDelegate,UINavigationBarDelegate>
@property (strong,nonatomic) CoverFlowView *coverFlowView;
@property (strong,nonatomic)MPMoviePlayerViewController *tmpMoviePlayViewController;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
//总页数
@property (assign, nonatomic) int total;
//视频index
@property (assign, nonatomic) int videoIndex;
//继续播放
- (void)continuePlay;
@end
