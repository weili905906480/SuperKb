//
//  DetailedCourseController.m
//  SuperKb
//
//  Created by weili on 14-9-22.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "DetailedCourseController.h"
#import "ARLabel.h"
#import "AddCourseController.h"
#import "ThridCell.h"
@implementation DetailedCourseController
@synthesize tableView=_tableView;
@synthesize res=_res;
@synthesize courseName=_courseName;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"display" object:nil];
    
    
    UIButton *right=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [right addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [right setBackgroundImage:[UIImage imageNamed:@"ic_navigation_back_normal"] forState:UIControlStateNormal];
    [right setBackgroundImage:[UIImage imageNamed:@"ic_navigation_back_pressed"] forState:UIControlStateSelected];
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.leftBarButtonItem=leftButton;
    UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithTitle:@"编辑" style:UIBarButtonItemStylePlain target:self action:@selector(modifyCourse:)];
    
    rightButton.tintColor=[UIColor blueColor];
    self.navigationItem.rightBarButtonItem=rightButton;
    
    
    
    ARLabel *label=[[ARLabel alloc]initWithFrame:CGRectMake(0, 0, 200, 30)];
    label.textColor=[UIColor blackColor];
    label.textAlignment=UITextAlignmentCenter;
    self.navigationItem.titleView=label;
    label.text=self.courseName;
    //创建表格
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 411)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    
     _tableView.backgroundColor=[UIColor colorWithRed:0.9373 green:0.9686 blue:0.9725 alpha:1];
    [self.view addSubview:_tableView];
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
#pragma table degelate method
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.row==0||indexPath.row==6||indexPath.row==7||indexPath.row==8||indexPath.row==9)
    {
        return 50;
    }else
    {
        return 40;
    }
     
}

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return  10;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    ThridCell *cell=[[ThridCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if(indexPath.section==0)
    {
        switch (indexPath.row) {
            case 0:
                cell.textLabel.text=@"课程";
                cell.detailTextLabel.text=_res.courseName;
                cell.image.image=[UIImage imageNamed:@"firstCell"];
                break;
            case 1:
                cell.textLabel.text=@"教室";
                cell.detailTextLabel.text=_res.classroom;                
                break;
            case 2:
                cell.textLabel.text=@"老师";
                cell.detailTextLabel.text=_res.teacher;
                break;
            case 3:
                cell.textLabel.text=@"班级";
                cell.detailTextLabel.text=_res.classes;
                break;
            case 4:
                cell.textLabel.text=@"周数";
                cell.detailTextLabel.text=_res.weekendLast;
                break;
            case 5:
                cell.textLabel.text=@"节数";
                cell.detailTextLabel.text=[NSString stringWithFormat:@"星期%d第%d节",_res.day,_res.jie];
                break;
            case 6:
                cell.image.image=[UIImage imageNamed:@"cell3_1"];
                break;
            case 7:
                cell.image.image=[UIImage imageNamed:@"cell3_1"];
                break;  
            case 8:
                cell.image.image=[UIImage imageNamed:@"cell3_1"];
                break;
            case 9:
                cell.image.image=[UIImage imageNamed:@"cell3_1"];
                UIImageView *view=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"line"]];
                view.frame=CGRectMake(0, 49, 320, 1);
                [cell.contentView addSubview:view];
                break;    
            
        }
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
//编辑按钮点击时触发的方法
-(void)modifyCourse:(UIBarButtonItem*) button
{
    AddCourseController *contro=[[AddCourseController alloc]init];
    contro.model=_res;
    contro.editOrmodify=Modify;
    [self.navigationController pushViewController:contro animated:YES];
    
}

//更新数据
-(void) refreshData:(NSNotification*) notifition
{
    NSDictionary *result=[notifition userInfo];
    _res=[result objectForKey:@"addModel"];
    [_tableView reloadData];
}

-(void) back:(UIBarButtonItem*) button
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
