//
//  ModifyCurrentWeek.m
//  SuperKb
//
//  Created by weili on 14-9-29.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "ModifyCurrentWeek.h"
#import "ARLabel.h"
@implementation ModifyCurrentWeek
@synthesize currentWeek=_currentWeek;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        
        self.title=@"选择当前周数";
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.tableView.rowHeight=50;
    self.tableView.scrollEnabled=NO;
    //self.tableView.backgroundColor=[UIColor grayColor];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self createView];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{

    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier];
        UIImageView *imageView=[[UIImageView alloc]initWithFrame:CGRectMake(0, 8, 320, 40)];
        imageView.image=[UIImage imageNamed:@"cellBackground"];
        [cell.contentView addSubview:imageView];        
    }

    cell.selectionStyle=UITableViewCellSelectionStyleNone;
   cell.textLabel.text=@"当前周";
    cell.detailTextLabel.text=_currentWeek;
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

-(void)createView
{
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 44)];
    
    [button setBackgroundImage:[UIImage imageNamed:@"ic_navigation_back_normal"] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:button];
    
    ARLabel *label=[[ARLabel alloc]initWithFrame:CGRectMake(5, 0, 100, 30)];
   
    label.textColor=[UIColor blackColor];
    label.text=@"选择当前周数";
    self.navigationItem.titleView=label;
    self.navigationItem.leftBarButtonItem=leftButton;
}

-(void) changeCurrentWeek
{
    //将修改的结果保存到NSUserDefaults文件中
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *userMessage=[defaults objectForKey:@"userMessage"];
    //修改当前周
    
    NSDate *date=[NSDate date];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *comps=nil;
    //获取当前的星期
    comps=[calendar components:NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit fromDate:date];
    
    int  week=[comps week];
    
    //同时记录下当前的周数
    
    //self.navigationItem.title=
    NSNumber *weekofYear=[NSNumber numberWithInt:week];
    [userMessage replaceObjectAtIndex:2 withObject:weekofYear];
    [userMessage replaceObjectAtIndex:1 withObject:self.navigationItem.title];

    [defaults setValue:userMessage forKey:@"userMessage"];
    
    [defaults synchronize];//同步数据
    
    //这里还要通知页面三更改页面显示的内容
    [[NSNotificationCenter defaultCenter] postNotificationName:@"userMessage" object:userMessage userInfo:nil];
}
-(void) back:(UIButton*) button
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
