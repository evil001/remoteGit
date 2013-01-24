//
//  MainPopoverViewController.m
//  BookReader
//
//  Created by wangyuxin on 13-1-24.
//
//

#import "MainPopoverViewController.h"

#define REQUEST_URL @"http://127.0.0.1:9091/?parmeter="
@interface MainPopoverViewController ()
-(NSData *) httpData:(NSString *)methodName;
@end

@implementation MainPopoverViewController
@synthesize seasonArray;
@synthesize saleArray;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(NSData *)httpData:(NSString *)methodName{
    NSMutableDictionary *directory = [[NSMutableDictionary alloc]init];
    NSString *paramJson;
    NSMutableString *urlStr = [[NSMutableString alloc] initWithString:REQUEST_URL];
    [directory setValue:@"AppServiceImpl" forKey:@"className"];
    [directory setValue:methodName forKey:@"methodName"];
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    NSData *data=[self httpData:@"queryAllSeasonInfo"];
    NSError *error ;
    seasonArray=[NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
	// Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if(tableView==self.seasonTableView){
        return 1;
    }else{
        return 1;
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if(tableView==self.seasonTableView){
        return [seasonArray count];
    }else{
        return 8;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if(tableView==self.seasonTableView){
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SeasonCell"];
        NSMutableDictionary *seasonDic=[seasonArray objectAtIndex:indexPath.row];
        cell.textLabel.text = [seasonDic objectForKey:@"seasonName"];
        return cell;
    }else{
        UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:@"SaleCell"];
        cell.textLabel.text = @"油画雕塑";
        return cell;
    }
}

- (void)viewDidUnload {
    [self setSeasonTableView:nil];
    [self setSaleTableView:nil];
    [self setSeasonArray:nil];
    [self setSaleArray:nil];
    [super viewDidUnload];
}
@end
