//
//  SortViewController.m
//  BookReader
//
//  Created by Dwen on 13-1-29.
//
//

#import "SortViewController.h"
#import "CatalogViewController.h"

@interface SortViewController ()

@end

@implementation SortViewController
@synthesize popover,sortArry;
@synthesize sortStr;
@synthesize specialCode;

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
         sortArry = [[NSMutableArray alloc] initWithObjects:@"成交价从低到高",@"成交价从高到低",@"图录序号从小到大",@"图录序号从大到小", nil];
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
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    //隐藏popover
    [popover dismissPopoverAnimated:YES];
    sortStr = [sortArry objectAtIndex:indexPath.row];
    NSLog(@"sortStr : %@ , specialCode :%@",sortStr,specialCode);
    CatalogViewController *catalogVC = [[CatalogViewController alloc] initWithNibName:@"CatalogViewController" bundle:nil :specialCode];
//    [self.navigationController pushViewController:catalogVC animated:YES];
}

@end
