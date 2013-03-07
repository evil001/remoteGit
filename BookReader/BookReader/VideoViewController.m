//
//  VideoViewController.m
//  BookReader
//
//  Created by Dwen on 13-3-6.
//
//

#import "VideoViewController.h"
#import "VideoListView.h"

#define PATHSTRING @"http://192.168.6.134:8080/upload/1.mp4"
//#define PATHSTRING @"http://www.archive.org/download/bb_poor_cinderella/bb_poor_cinderella_512kb.mp4"

//每行显示限制数
#define ROW_LIMIT 5

@interface VideoViewController ()

@end

@implementation VideoViewController
@synthesize tmpMoviePlayViewController;
@synthesize scrollView;
@synthesize total;
@synthesize videoIndex;
@synthesize coverFlowView;

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
    self.title = @"视频专区";
    total = 23;//总数
    //播放状态通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moviePlayerPlaybackStateChanged:) name:MPMoviePlayerPlaybackStateDidChangeNotification object:nil];
    //保存当前视频播放时间通知(**为解决当正在播放时，用户按home键使程序进入后台并暂停工作，当用户再次点击程序时，需回去开始退出视频的播放点继续播放)
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(saveCurrentPalyTime) name:@"SaveCurrentPalyBackTime" object:nil];
    //继续播放通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(continuePlay) name:@"ContinuePlayBack" object:nil];
    
    [self initCoverFlowView];
    [self initVideoListView];
}

//初始化滑动视图
- (void)initCoverFlowView{
    //设滑动视图坐标及大小
	self.view.backgroundColor = [UIColor lightGrayColor];
    CGRect rect = CGRectMake(0, -40, 1024, 400);
    //初始化视频滑动效果图
    NSMutableArray *sourceImages = [NSMutableArray arrayWithCapacity:20];
    for (int i = 0; i <total; i++) {
        UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg", i]];
        [sourceImages addObject:image];
    }
    //滑动效果视图
    coverFlowView = [CoverFlowView coverFlowViewWithFrame:rect andImages:sourceImages sideImageCount:3 sideImageScale:0.35 middleImageScale:0.6];
    [coverFlowView bringSubviewToFront:coverFlowView.videoTitle];
    //点击手势
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playMovie_2)];
    [coverFlowView addGestureRecognizer:tap];
    [self.view addSubview:coverFlowView];
}

//初始化视频列表
- (void)initVideoListView{
    //scrollView控件
    scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 410, 1024, 500)];
    [scrollView setDelegate:self];
    scrollView.pagingEnabled = YES;
    [scrollView setScrollEnabled:YES];
    [scrollView setShowsHorizontalScrollIndicator:NO];
    [scrollView setShowsVerticalScrollIndicator:NO];
    [self.view addSubview:scrollView];
    
    //视频列表
    int rowNum = total/ROW_LIMIT;//行数
    int lastNum = total%ROW_LIMIT;//不足一行数量
    //刚好整行的情况
    for (int i=0; i<rowNum; i++) {
        UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(10, i*193, 1004, 171)];
        pageView.backgroundColor = [UIColor whiteColor];
        for (int j=i*ROW_LIMIT; j<(i+1)*ROW_LIMIT; j++) {
            VideoListView *videoListView = [[[NSBundle mainBundle] loadNibNamed:@"VideoListView" owner:self options:nil] lastObject];
            videoListView.frame = CGRectMake((j%ROW_LIMIT)*200+20, 0, videoListView.frame.size.width, videoListView.frame.size.height);
            //TODO此处需添加图片缓存
            [videoListView.imageView setImage:[UIImage imageNamed:@"1.jpg"]];
            //添加图片点击事件
            videoListView.imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playMovie:)];
            [videoListView.imageView addGestureRecognizer:tap];
            videoListView.imageView.tag = j;
            videoListView.videoDescr.text = @"解析唐朝文物";
            [pageView addSubview:videoListView];
            [scrollView addSubview:pageView];
        }
    }
    //最后一行不足整行的情况
    if (lastNum>0) {
        UIView *pageView = [[UIView alloc] initWithFrame:CGRectMake(10, (rowNum+1)*154, 1004, 171)];
        pageView.backgroundColor = [UIColor whiteColor];
        NSLog(@"%i,%i",rowNum*ROW_LIMIT,total);
        for (int j=rowNum*ROW_LIMIT; j<total; j++) {
            VideoListView *videoListView = [[[NSBundle mainBundle] loadNibNamed:@"VideoListView" owner:self options:nil] lastObject];
            videoListView.frame = CGRectMake((j%ROW_LIMIT)*200+20, 0, videoListView.frame.size.width, videoListView.frame.size.height);
            //TODO此处需添加图片缓存
            [videoListView.imageView setImage:[UIImage imageNamed:@"1.jpg"]];
            //添加图片点击事件
            videoListView.imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playMovie:)];
            [videoListView.imageView addGestureRecognizer:tap];
            videoListView.imageView.tag = j;
            videoListView.videoDescr.text = @"解析唐朝文物——1";
            [pageView addSubview:videoListView];
            [scrollView addSubview:pageView];
        }
        //设置滚动范围
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 250*(rowNum+1))];
    }else{
        //设置滚动范围
        [scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 250*rowNum)];
    }
}

#pragma make Moive
//从列表点播视频
- (void)playMovie:(id)sender{
    NSInteger index = [(UIGestureRecognizer *)sender view].tag;
    NSLog(@"index---------%i",index);
    [self initPlay:PATHSTRING];
}

//从广告图点播视频
- (void)playMovie_2{
    NSLog(@"广告图点播视频index------%i",coverFlowView.currentRenderingImageIndex);
    [self initPlay:PATHSTRING];
}

//播放
- (void)initPlay : (NSString *)pathString{
    NSURL *URL = [NSURL URLWithString:pathString];
    if (URL) {
        tmpMoviePlayViewController = [[MPMoviePlayerViewController alloc] initWithContentURL:URL];
        
        [self presentMoviePlayerViewControllerAnimated:tmpMoviePlayViewController];
        tmpMoviePlayViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:tmpMoviePlayViewController];
        [tmpMoviePlayViewController.moviePlayer play];
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//播放状态
- (void)moviePlayerPlaybackStateChanged:(NSNotification *)notification{
    MPMoviePlayerController *moviePlayer = notification.object;
    MPMoviePlaybackState palybackState = moviePlayer.playbackState;
    switch (palybackState) {
        case MPMoviePlaybackStateStopped:
            NSLog(@"stop");
            break;
        case MPMoviePlaybackStatePlaying:
            NSLog(@"playing");
            break;
        case MPMoviePlaybackStatePaused:
            //暂停有两种情况，一种是人为暂停，另一种是网络异常
            NSLog(@"paused");
            break;
        case MPMoviePlaybackStateInterrupted:
            NSLog(@"Interrupted");
            break;
        case MPMoviePlaybackStateSeekingForward:
            NSLog(@"forward");
            break;
        case MPMoviePlaybackStateSeekingBackward:
            NSLog(@"backword");
            break;
        default:
            break;
    }
}

//按home键进入后台后，重新到开始时间点播放
- (void)continuePlay{
    NSURL *URL = [NSURL URLWithString:PATHSTRING];
    if (URL) {
        [self presentMoviePlayerViewControllerAnimated:tmpMoviePlayViewController];
        tmpMoviePlayViewController.moviePlayer.movieSourceType = MPMovieSourceTypeFile;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackDidFinish:) name:MPMoviePlayerPlaybackDidFinishNotification object:tmpMoviePlayViewController];
        //续上次播放时间初始化到当前时间
        [tmpMoviePlayViewController.moviePlayer setInitialPlaybackTime:[[NSUserDefaults standardUserDefaults] floatForKey:@"MOVIE_TIME"]];
        [tmpMoviePlayViewController.moviePlayer play];
        NSLog(@"play...");
    }else{
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"文件不存在" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}

//保存当前播放时间
- (void)saveCurrentPalyTime{
    [[NSUserDefaults standardUserDefaults] setFloat:[self.tmpMoviePlayViewController.moviePlayer currentPlaybackTime] forKey:@"MOVIE_TIME"];
}

//播完后关闭视频
-(void)playbackDidFinish:(NSNotification *)noti
{
    MPMoviePlayerViewController * mpv = [noti object];
    [mpv dismissMoviePlayerViewControllerAnimated];
}

//横屏
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation{
    return (toInterfaceOrientation == UIInterfaceOrientationLandscapeRight);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"--------didReceiveMemoryWarning");
}

- (void)viewDidUnload{
    //清除通知，不然会报异常
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
