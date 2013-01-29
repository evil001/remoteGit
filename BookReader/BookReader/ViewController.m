//
//  ViewController.m
//  BookReader
//
//  Created by 晓军 唐 on 13-1-7.
//  Copyright (c) 2013年 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "MyCellView.h"
#import "MyBookView.h"
#import "ImageScanViewController.h"
#import "MyBelowBottomView.h"
#import "Utils.h"
#import "CatalogViewController.h"
#import <Foundation/NSJSONSerialization.h> 

@interface ViewController ()
@property (strong,nonatomic) UIActivityIndicatorView *activityIndecatorView;
@property (nonatomic,strong) NSMutableData *responseData;
@end

@implementation ViewController
@synthesize responseData = _responseData;
@synthesize activityIndecatorView;
@synthesize currentPopoverSegue;
@synthesize popover;

-(void)didReceiveMemoryWarning{
    [super didReceiveMemoryWarning];
}

//初始化数据
- (void)initBooks{
    
    [self requestImageData];
    NSInteger numberOfBooks = [_bookArray count];
    _bookStatus = [[NSMutableArray alloc] initWithCapacity:numberOfBooks];
    for (int i =0; i<numberOfBooks; i++) {
        [_bookStatus addObject:[NSNumber numberWithInt:BOOK_UNSELECTED]];
    }
    
    _booksIndexsToBeRemoved = [NSMutableIndexSet indexSet];
}

-(NSData *)httpData:(NSString *)methodName:(NSString *)parameter{
    NSMutableDictionary *directory = [[NSMutableDictionary alloc]init];
    NSString *paramJson;
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:REQUEST_URL];
    [directory setValue:@"AppServiceImpl" forKey:@"className"];
    [directory setValue:methodName forKey:@"methodName"];
    if(parameter!=nil){
        [directory setValue:parameter forKey:@"parameter"];
    }
    if ([NSJSONSerialization isValidJSONObject:directory]) {
        NSError *error ;
        NSData *jsonData = [NSJSONSerialization dataWithJSONObject:directory options:NSJSONWritingPrettyPrinted error:&error];
        paramJson =[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        paramJson = [paramJson stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    }
    [urlStr appendString:paramJson];
    NSURL *url = [NSURL URLWithString:urlStr];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:url];
    [request setHTTPMethod:@"POST"];
    NSHTTPURLResponse *response;
    NSData *data = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return data;
}

- (void) requestImageData{
    NSData *data=[self httpData:@"queryAllCatelogInfo":nil];
    NSError *error ;
    NSDictionary *imageDictory = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *imageUrl = [imageDictory valueForKey:@"imageUrl"];
    _bookArray = [[NSMutableArray alloc]initWithArray:imageUrl];
}

-(void)initBarButtons{
//    _editBarButton = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemEdit
//                                                                  target:self action:@selector(editButtonClicked:)];
//    _cancleBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancleButtonClicked:)];
//    
//    _trashBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemTrash target:self action:@selector(trashButtonClicked:)];
//    _addBarButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addButtonClicked:)];
    
}

- (void)switchToNormalMode {
    _editMode = NO;
    
    [self.navigationItem setLeftBarButtonItem:_editBarButton];
    [self.navigationItem setRightBarButtonItem:_addBarButton];
}

//选择编辑模式
- (void)switchToEditMode {
    _editMode = YES;
    [_booksIndexsToBeRemoved removeAllIndexes];
    [self.navigationItem setLeftBarButtonItem:_cancleBarButton];
    [self.navigationItem setRightBarButtonItem:_trashBarButton];
    
    for (int i = 0; i < [_bookArray count]; i++) {
        [_bookStatus addObject:[NSNumber numberWithInt:BOOK_UNSELECTED]];
    }
    
    for (MyBookView *bookView in [_bookShelfView visibleBookViews]) {
        [bookView setSelected:NO];
    }
}

- (void)viewDidLoad
{
    activityIndecatorView = [[UIActivityIndicatorView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2, self.view.frame.size.height/2, 50, 50)];
    [super viewDidLoad];
    [self initBarButtons];
	[self initBooks];
    activityIndecatorView.activityIndicatorViewStyle = UIActionSheetStyleBlackTranslucent;
    activityIndecatorView.hidesWhenStopped = YES;
//    activityIndecatorView.center = self.view.center;
    
    self.title=@"电子图录";
    if (self.interfaceOrientation == UIDeviceOrientationPortrait||self.interfaceOrientation==UIDeviceOrientationPortraitUpsideDown) {
//        _searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, 768, 44)];
        _belowBottomView = [[MyBelowBottomView alloc]initWithFrame:CGRectMake(0, 40, 768, 1024)];
        _bookShelfView = [[GSBookShelfView alloc]initWithFrame:CGRectMake(0, 0, 768, 1024)];
    }else {
//        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0, 0, 768, 44)];
        _belowBottomView = [[MyBelowBottomView alloc] initWithFrame:CGRectMake(0, 40, 1024, 768)];
        _bookShelfView = [[GSBookShelfView alloc] initWithFrame:CGRectMake(0, 0, 1024, 768)];
    }
    
    //MyBelowBottomView *belowBottom = [[MyBelowBottomView alloc] initWithFrame:CGRectMake(0, 0, 320, CELL_HEIGHT * 2)];
    
    [_bookShelfView setDataSource:self];
    //[_bookShelfView setShelfViewDelegate:self];
    
    [self.view addSubview:_bookShelfView];
    [self.view addSubview:activityIndecatorView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
//    if (UIInterfaceOrientationIsLandscape(interfaceOrientation)) {
//        return YES;
//    }
//    return NO;
    return YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
    
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (UIInterfaceOrientationPortrait ==orientation) {
        [_bookShelfView setFrame:CGRectMake(0, 0, 768, 1024)];
    }else if (UIInterfaceOrientationLandscapeLeft == orientation) {
        [_bookShelfView setFrame:CGRectMake(0, 0, 1024, 768)];
    }else if (UIInterfaceOrientationLandscapeRight == orientation) {
        [_bookShelfView setFrame:CGRectMake(0, 0, 1024, 768)];
    }else if (UIInterfaceOrientationPortraitUpsideDown == orientation) {
        [_bookShelfView setFrame:CGRectMake(0, 0, 768, 1024)];
    }
    else {
        [_bookShelfView setFrame:CGRectMake(0, 0, 1024, 800 - 44)];
    }
    [_bookShelfView reloadData];
}

- (NSInteger)numberOfBooksInBookShelfView:(GSBookShelfView *)bookShelfView {
    return [_bookArray count];
}

//一行显示几个
- (NSInteger)numberOFBooksInCellOfBookShelfView:(GSBookShelfView *)bookShelfView {
    NSInteger row = 0;
    if (self.interfaceOrientation == UIInterfaceOrientationPortrait) {
        row = 4;
    }else if (self.interfaceOrientation == UIInterfaceOrientationPortraitUpsideDown) {
        row = 4;
    }else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeLeft) {
        row = 5;
    }else if (self.interfaceOrientation == UIInterfaceOrientationLandscapeRight) {
        row = 5;
    }
    return row;
}

- (UIView *)bookShelfView:(GSBookShelfView *)bookShelfView bookViewAtIndex:(NSInteger)index {
    [activityIndecatorView startAnimating];
    static NSString *identifier = @"bookView";
    MyBookView *bookView = (MyBookView *)[bookShelfView dequeueReuseableBookViewWithIdentifier:identifier];
    if (bookView == nil) {
        bookView = [[MyBookView alloc] initWithFrame:CGRectZero];
        bookView.reuseIdentifier = identifier;
        [bookView addTarget:self action:@selector(bookViewClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    [bookView setIndex:index];
    [bookView setSelected:[(NSNumber *)[_bookStatus objectAtIndex:index] intValue]];
    //    int imageNO = [(NSNumber *)[_bookArray objectAtIndex:index] intValue] % 4 + 1;
//    int imageNO = index%4+1;
    UIImageView *asyncImage = [[UIImageView alloc]init];
    [asyncImage setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:CATALOG_URL, [_bookArray objectAtIndex:index]]]placeholderImage:[UIImage imageNamed:@"placeholder.png"]];
    [asyncImage setFrame:CGRectMake(0, 0, 110, 140)];
    [bookView addSubview:asyncImage];
    [activityIndecatorView stopAnimating];
//    [bookView setBackgroundImage:[asyncImage image] forState:UIControlStateNormal];
    return bookView;
}

- (void)webImageManager:(SDWebImageManager *)imageManager didFinishWithImage:(UIImage *)image forURL:(NSURL *)url userInfo:(NSDictionary *)info{
}

- (UIView *)bookShelfView:(GSBookShelfView *)bookShelfView cellForRow:(NSInteger)row {
    static NSString *identifier = @"cell";
    MyCellView *cellView = (MyCellView *)[bookShelfView dequeueReuseableCellViewWithIdentifier:identifier];
    if (cellView == nil) {
        cellView = [[MyCellView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
        cellView.reuseIdentifier = identifier;
    }
    return cellView;
}

- (UIView *)aboveTopViewOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return nil;
}

- (UIView *)belowBottomViewOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return _belowBottomView;
}

- (UIView *)headerViewOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return nil;
}

- (CGFloat)cellHeightOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 170.0f;
}

//距离左右边框得距离
- (CGFloat)cellMarginOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 50.0f;
}

//图录的高
- (CGFloat)bookViewHeightOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 140.0f;
}

//图录的宽
- (CGFloat)bookViewWidthOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 110.0f;
}

//距离底部得距离
- (CGFloat)bookViewBottomOffsetOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 160.0f;
}

//阴影得高度
- (CGFloat)cellShadowHeightOfBookShelfView:(GSBookShelfView *)bookShelfView {
    return 40.0f;
}

//移动图录调用得方法
- (void)bookShelfView:(GSBookShelfView *)bookShelfView moveBookFromIndex:(NSInteger)fromIndex toIndex:(NSInteger)toIndex {
    if ([(NSNumber *)[_bookStatus objectAtIndex:fromIndex] intValue] == BOOK_SELECTED) {
        [_booksIndexsToBeRemoved removeIndex:fromIndex];
        [_booksIndexsToBeRemoved addIndex:toIndex];
    }
    
    [_bookArray moveObjectFromIndex:fromIndex toIndex:toIndex];
    [_bookStatus moveObjectFromIndex:fromIndex toIndex:toIndex];
    // the bookview is recognized by index in the demo, so change all the indexes of affected bookViews here
    // This is just a example, not a good one.In your code, you'd better use a key to recognize the bookView.
    // and you won't need to do the following
    MyBookView *bookView;
    bookView = (MyBookView *)[_bookShelfView bookViewAtIndex:toIndex];
    [bookView setIndex:toIndex];
    if (fromIndex <= toIndex) {
        for (int i = fromIndex; i < toIndex; i++) {
            bookView = (MyBookView *)[_bookShelfView bookViewAtIndex:i];
            [bookView setIndex:bookView.index - 1];
        }
    }
    else {
        for (int i = toIndex + 1; i <= fromIndex; i++) {
            bookView = (MyBookView *)[_bookShelfView bookViewAtIndex:i];
            [bookView setIndex:bookView.index + 1];
        }
    }
}

//编辑按钮
- (void)editButtonClicked:(id)sender {
    [self switchToEditMode];
}

//取消按钮
- (void)cancleButtonClicked:(id)sender {
    [self switchToNormalMode];
}

//点击删除按钮
- (void)trashButtonClicked:(id)sender {
    [_bookArray removeObjectsAtIndexes:_booksIndexsToBeRemoved];
    [_bookStatus removeObjectsAtIndexes:_booksIndexsToBeRemoved];
    [_bookShelfView removeBookViewsAtIndexs:_booksIndexsToBeRemoved animate:YES];
    [self switchToNormalMode];
}

- (void)addButtonClicked:(id)sender {
    [activityIndecatorView startAnimating];
    int a[6] = {1, 2, 5, 7, 9, 22};
    NSMutableIndexSet *indexSet = [NSMutableIndexSet indexSet];
    NSMutableArray *arr = [NSMutableArray array];
    NSMutableArray *stat = [NSMutableArray array];
    for (int i = 0; i < 6; i++) {
        [indexSet addIndex:a[i]];
        [arr addObject:[NSNumber numberWithInt:1]];
        [stat addObject:[NSNumber numberWithInt:BOOK_UNSELECTED]];
    }
    [_bookArray insertObjects:arr atIndexes:indexSet];
    [_bookStatus insertObjects:stat atIndexes:indexSet];
    [_bookShelfView insertBookViewsAtIndexs:indexSet animate:YES];
}

- (void)bookViewClicked:(UIButton *)button {
//    self.activityIndecatorView.hidden = NO;
    MyBookView *bookView = (MyBookView *)button;
    NSString *imgUrl = [[NSString alloc] initWithString:[_bookArray objectAtIndex:[bookView index]]];
    if (_editMode) {
        NSNumber *status = [NSNumber numberWithInt:bookView.selected];
        [_bookStatus replaceObjectAtIndex:bookView.index withObject:status];
        
        if (bookView.selected) {
            [_booksIndexsToBeRemoved addIndex:bookView.index];
        }
        else {
            [_booksIndexsToBeRemoved removeIndex:bookView.index];
        }
    }else {
//        CatalogViewController *catalogVC = [[CatalogViewController alloc] initWithNibName:@"CatalogViewController" bundle:nil :imgUrl];
//        [self.navigationController pushViewController:catalogVC animated:YES];
        
        ImageScanViewController *imageScan = [[ImageScanViewController alloc]init];
        imageScan.specialCode = imgUrl;
        [self.navigationController pushViewController:imageScan animated:YES];
    }
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{    
    if([segue.identifier isEqualToString:@"showPo"]){
        currentPopoverSegue = (UIStoryboardPopoverSegue *)segue;
        popover=currentPopoverSegue.destinationViewController;
        [popover setDelegate:self];
    }
}

-(void)popoverControllerDidDismissPopover:(UIPopoverController *)popoverController{
    
}


-(void)dismissPop:(NSString *)value{
    NSData *data=[self httpData:@"queryCatelogInfoById":value];
    NSError *error ;
    NSDictionary *imageDictory = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    NSArray *imageUrl = [imageDictory valueForKey:@"imageUrl"];
    _bookArray = [[NSMutableArray alloc]initWithArray:imageUrl];
    [_bookShelfView reloadData];
    [[currentPopoverSegue popoverController] dismissPopoverAnimated: YES];
}
@end
