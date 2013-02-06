//
//  SortViewController.m
//  BookReader
//
//  Created by Dwen on 13-1-29.
//
//

#import "SortViewController.h"
#import "CatalogViewController.h"
#import "Utils.h"

@interface SortViewController ()

@end

@implementation SortViewController
@synthesize popover,sortArry;
@synthesize sortStr;
@synthesize specialCode;
@synthesize delegate;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
         sortArry = [[NSMutableArray alloc] initWithObjects:CLOSE_COST_ASC,CLOSE_COST_DESC,LOT_ASC,LOT_DESC, nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
   return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [sortArry count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textLabel.text = [sortArry objectAtIndex:indexPath.row];
    cell.textLabel.font = [UIFont fontWithName:@"Arial" size:18];
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //隐藏popover
    [popover dismissPopoverAnimated:YES];
    sortStr = [sortArry objectAtIndex:indexPath.row];
    RequestVO *requestVO = [[RequestVO alloc] init];
    if ([sortStr isEqualToString:CLOSE_COST_ASC]) {//成交价升序
        [requestVO setSpecialCode:specialCode];
        [requestVO setOrderPa:CLOSE_COST_TYPE];
        [requestVO setSort:ASC];
    }
    if ([sortStr isEqualToString:CLOSE_COST_DESC]) {//成交价降序
        [requestVO setSpecialCode:specialCode];
        [requestVO setOrderPa:CLOSE_COST_TYPE];
        [requestVO setSort:DESC];
    }
    if ([sortStr isEqualToString:LOT_ASC]) {//lot升序
        [requestVO setSpecialCode:specialCode];
        [requestVO setOrderPa:LOT_TYPE];
        [requestVO setSort:ASC];
    }
    if ([sortStr isEqualToString:LOT_DESC]) {//lot降序
        [requestVO setSpecialCode:specialCode];
        [requestVO setOrderPa:LOT_TYPE];
        [requestVO setSort:DESC];
    }
    [requestVO setSortTypeStr:sortStr];
    [delegate loadDataShow:requestVO];//代理方法解决调用Controller问题
}

@end
