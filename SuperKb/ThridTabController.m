//
//  ThridTabController.m
//  SuperKb
//
//  Created by weili on 14-9-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "ThridTabController.h"
#import "ThridCell.h"
#import "AllTablesController.h"
@interface ThridTabController() {
@private
    NSArray *array;
    NSMutableArray *data;
}

@end
@implementation ThridTabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"ic_tabbar_settin_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_tabbar_settin_normal"]]; 
        [self.tabBarItem setTitle:@"我"];        
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor
        blackColor],UITextAttributeTextColor,[UIFont systemFontOfSize:12],UITextAttributeFont, nil];
        NSDictionary *select=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.0431 green:0.6588 blue:1.0000 alpha:1], UITextAttributeTextColor,nil];
        self.title=@"我";
        [self.tabBarItem setTitleTextAttributes:dic forState:UIControlStateNormal];
        [self.tabBarItem setTitleTextAttributes:select forState:UIControlStateSelected];
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
    
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 367)];
    
    table.backgroundColor=[UIColor colorWithRed:0.9451 green:0.9608 blue:0.9725 alpha:1];
    //NSString *path=[[NSBundle mainBundle] pathForResource:@"UserMessage" ofType:@"plist"];
    //NSDictionary *result=[[NSDictionary alloc]initWithContentsOfFile:path];
    
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray *arr=[defaults objectForKey:@"userMessage"];
    
    //table.separatorStyle=UITableViewCellSeparatorStyleNone;
    data=[NSMutableArray array];
    for(int i=0;i<arr.count;i++)
    {
        if(i!=2)
        {
            [data addObject:[arr objectAtIndex:i]];
        }
    }
    
    /*UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor=[UIColor colorWithRed:0.9373 green:0.9686 blue:0.9725 alpha:1];
    
    table.tableHeaderView=view;*/
    
    
    table.backgroundColor=[UIColor colorWithRed:0.9373 green:0.9686 blue:0.9725 alpha:1];

    table.dataSource=self;
    table.delegate=self;
    array=[NSArray arrayWithObjects:@"当前学期",@"当前周数",@"课表背景",@"每日最大节数",@"一周起始日", nil];
    [self.view addSubview:table];
    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/*-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}*/

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
     if((indexPath.section==2&&indexPath.row==0)||(indexPath.section==4&&indexPath.row==0))
     {
         return 50;
     }
    
    if(indexPath.section==0||indexPath.section==1||indexPath.section==3||indexPath.section==5||indexPath.section==6)
    {
        return 50;
    }else
    {
        return 40;
    }
     
}


-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 7;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0||section==1||section==3||section==5||section==6)
    {
        return 1;
    }else if(section==2)
    {
        return 5;
    }else
    {
        return 2;
    }
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifity=@"cell";
    ThridCell *cell=[tableView dequeueReusableCellWithIdentifier:identifity];
    if(cell==nil)
    {
        cell=[[ThridCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:identifity];
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;

    
    if(indexPath.section==0)
    {
    cell.textLabel.text=@"个人资料";
        cell.image.image=[UIImage imageNamed:@"firstCell"];    
    }else if(indexPath.section==1)
    {
        cell.textLabel.text=@"课表二维码";
        cell.detailTextLabel.text=@"";
      cell.image.image=[UIImage imageNamed:@"cell3_1"];
    }else if(indexPath.section==3)
    {
        cell.textLabel.text=@"每日提醒";
        cell.detailTextLabel.text=[data objectAtIndex:5];
        cell.image.image=[UIImage imageNamed:@"cell3_1"];
    }else if(indexPath.section==5)
    {
        cell.textLabel.text=@"推荐给好友";
        cell.detailTextLabel.text=@"";
        cell.image.image=[UIImage imageNamed:@"cell3_1"];
    }else if(indexPath.section==6)
    {
        cell.textLabel.text=@"切换课表";
        cell.detailTextLabel.text=@"";
        cell.image.image=[UIImage imageNamed:@"cell3_1"];
    }else if(indexPath.section==4)
    {
        if(indexPath.row==0)
        {
            cell.textLabel.text=@"自助服务";
            cell.image.image=[UIImage imageNamed:@"cell3_1"];
        }else{
            cell.textLabel.text=@"软件相关";
            cell.image.image=nil;
        }
        cell.detailTextLabel.text=@"";
    }else if(indexPath.section==2)
    {
        if(indexPath.row==0)
        {
            cell.image.image=[UIImage imageNamed:@"cell3_1"]; 
        }else{
            cell.image.image=nil;
        }
        cell.textLabel.text=[array objectAtIndex:indexPath.row];
        cell.detailTextLabel.text=[data objectAtIndex:indexPath.row];
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    //cell.contentView.backgroundColor=[UIColor blueColor];
    return cell;
}

/*-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
    view.backgroundColor=[UIColor redColor];
    return view;
}*/

#pragma tableView  delegate
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==6&&indexPath.row==0)
    {
        AllTablesController *control=[[AllTablesController alloc]initWithStyle:UITableViewStyleGrouped];
        [self.navigationController pushViewController:control animated:YES];
    }
    
}
@end
