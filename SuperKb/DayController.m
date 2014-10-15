//
//  DayController.m
//  SuperKb
//
//  Created by weili on 14-9-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "DayController.h"
#import "ARLabel.h"
#import "CourseModelToDB.h"
#import "DayTableViewCell.h"
#import "DetailedCourseController.h"
#import "AddCourseController.h"
#import "CourseDBService.h"
#define TableHEIGHT 320
#define SCROLLViewHeight 320
@interface DayController() {
@private
    UITableView *tableView;
    NSMutableArray *tableData;
    UIScrollView *scrollView;
    UIButton *selectedButton;
    UILabel *label;
    CourseModelToDB *addModel;
}
//这个方法根据星期数得到结果
-(NSMutableArray*) getModels:(int) weekday;
@end
@implementation DayController
@synthesize delegate=_delegate;
@synthesize allCourse=_allCourse;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
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
    
    //这个类也应该收听一个通知
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshData:) name:@"display" object:nil];
    
    
    //这里不要让scrollview在垂直方向滚动
    scrollView=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 40, 320, SCROLLViewHeight)];
    scrollView.contentSize=CGSizeMake(7*320, 300);
    scrollView.showsHorizontalScrollIndicator=NO;
    scrollView.pagingEnabled=YES;
    scrollView.delegate=self;
    scrollView.directionalLockEnabled=YES;
    [self.view addSubview:scrollView];    
    
    self.view.backgroundColor=[UIColor whiteColor];
    //创建头部的视图
    NSDate *date=[NSDate date];
    //获取当前日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *comps=nil;
    
    
    //获取当前的星期
    
    comps=[calendar components:NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:date];
    int weekday1=[comps weekday];
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"MM"];
    int mon=[[formater  stringFromDate:date] intValue] ;
    NSString *monthStr=[NSString stringWithFormat:@"%d月",mon];
    //创建一个头部视图
    ARLabel *month=[[ARLabel alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
    month.text=monthStr;
    //UIView *tableHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    
    [self.view addSubview:month];
    int weekday;
    int day;
    NSDate *dateWeek;
    for(int i=0;i<7;i++)
    {
        
        if(weekday1==1)//星期天
        { 
            dateWeek=[NSDate dateWithTimeInterval:24*60*60*(i-6) sinceDate:date];
            
        }else{
           dateWeek=[NSDate dateWithTimeInterval:24*60*60*(i-weekday1+2) sinceDate:date];
        }
        //获取当前时间和星期数
        comps=[calendar components:NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:dateWeek];
        weekday=[comps weekday];
        day=[comps day];              
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(20+i*43, 0, 43, 40)];
        button.titleLabel.lineBreakMode=0;
        button.titleLabel.font=[UIFont systemFontOfSize:9];
        if(weekday==1)
        {
            [button  setTitle:[NSString stringWithFormat:@"  %d\n%d",day-6+i, i+1] forState:UIControlStateNormal];            
        }else{
        [button setTitle:[NSString stringWithFormat:@"%d\n%d",day-weekday+2+i ,i+1] forState:UIControlStateNormal];
        }
        if(weekday1-2==i)
        {
            button.selected=YES;
            selectedButton=button;
        }
        [button setTitleColor:[UIColor redColor] forState:UIControlStateSelected];
        button.tag=151+i;
        [button addTarget:self action:@selector(pageChange:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [self.view addSubview:button];
    }
    if(weekday1-2>=0)
    {
        tableView=[[UITableView alloc]initWithFrame:CGRectMake((weekday1-2)*320, 0, 320, TableHEIGHT) style:UITableViewStylePlain];
        tableData=[self getModels:weekday1-1];
        label=[[UILabel alloc]initWithFrame:CGRectMake(20+(weekday1-2)*43, 37, 43, 3)];
        label.backgroundColor=[UIColor blueColor];
        [self.view addSubview:label];
        [scrollView scrollRectToVisible:CGRectMake((weekday1-2)*320, 0, 320, SCROLLViewHeight) animated:YES];
    }else{
        tableView=[[UITableView alloc]initWithFrame:CGRectMake(6*320, 0, 320, TableHEIGHT) style:UITableViewStylePlain];
        tableData=[self getModels:7];
        label=[[UILabel alloc]initWithFrame:CGRectMake(20+6*43, 37, 43, 3)];
        label.backgroundColor=[UIColor blueColor];
        [self.view addSubview:label];        
        [scrollView scrollRectToVisible:CGRectMake(6*320, 0, 320, SCROLLViewHeight) animated:YES];
    }
    tableView.dataSource=self;
    tableView.delegate=self;
    [scrollView addSubview:tableView];
    
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

-(void) pageChange:(UIButton*) button
{
     if(selectedButton!=nil)
     {
         selectedButton.selected=NO;
     }
    tableData=[self getModels:button.tag-150];
    //改变滚动条的frame
    [UIView animateWithDuration:0.2 animations:^() {
        label.frame=CGRectMake(20+(button.tag-151)*43, 37, 42, 3);
    }];
    //改变表格的frame
    tableView.frame=CGRectMake((button.tag-151)*320, 0, 320, TableHEIGHT);
    [scrollView scrollRectToVisible:CGRectMake((button.tag-151)*320, 0, 320, SCROLLViewHeight) animated:YES];
    [tableView reloadData];
    button.selected=YES;
    selectedButton=button;
}

#pragma tableView delegate method

-(CGFloat) tableView:(UITableView *)tableView1 heightForRowAtIndexPath:(NSIndexPath *)indexPath
{

    return 60;
    
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DayTableViewCell *cell=[[DayTableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    cell.jie.text=[NSString stringWithFormat:@"0%d",indexPath.row+1];
      cell.jie.textColor=[UIColor grayColor];
    for(int i=0;i<tableData.count;i++)
    {
        CourseModelToDB *model=[tableData objectAtIndex:i];
        if(model.jie==indexPath.row+1){
            cell.courseName.text=model.courseName;
            cell.classRoom.text=model.classroom;
            cell.week.text=model.weekendLast;
            cell.jie.textColor=[UIColor orangeColor];
            cell.time.text=@"未设定时间";
        }
    }
  
    return cell;
}

-(NSMutableArray*) getModels:(int)weekday
{
    NSMutableArray *res=[NSMutableArray array];
    for(CourseModelToDB *model in _allCourse)
    {
        if(weekday==model.day)
        {
            [res addObject:model];
        }
    }
    return res;
}
-(void) scrollViewDidEndDecelerating:(UIScrollView *)scrollView1
{
    //这里要判断是那个view在滑动
    if([scrollView1 isMemberOfClass:[UIScrollView class]])
    {
        if(selectedButton!=nil)
        {
            selectedButton.selected=NO;
        }    
    int weekend=(int)scrollView1.contentOffset.x/320+1;
        
    [UIView animateWithDuration:0.2 animations:^() {
       label.frame=CGRectMake(20+43*(weekend-1), 37, 40, 3);
       }];  
    tableData=[self getModels:weekend];
    //NSLog(@"weekend=%d",weekend);
    UIButton *button=(UIButton*)[self.view viewWithTag:150+weekend];
    tableView.frame=CGRectMake((weekend-1)*320, 0, 320, TableHEIGHT);
    button.selected=YES;
    [tableView reloadData];
    selectedButton=button;
  }
}
//跳转到detailedController上
-(void) tableView:(UITableView *)tableView1 didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView1 cellForRowAtIndexPath:indexPath];
    int weekday=selectedButton.tag-150;
    NSMutableArray *result=[self getModels:weekday];
    for(CourseModelToDB *model in result)
    {
        if(model.jie==indexPath.row+1)
        {
            DetailedCourseController *con=[[DetailedCourseController alloc]init];
            con.res=model;
            //使用代理来进行跳转
            [self.delegate gotoDetailed:con];
            return;
        }
    }
   //添加一个按钮，来增加课程
    UIButton *button=(UIButton*)[cell viewWithTag:155];
    if(button==nil){
    button=[[UIButton alloc]initWithFrame:CGRectMake(40, 10, 100, 40)];
    button.titleLabel.font=[UIFont systemFontOfSize:10];
    [button setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        button.tag=155;
    [button addTarget:self action:@selector(addCourse:) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"添加课程" forState:UIControlStateNormal];
    [cell.contentView addSubview:button];
    }
    addModel=[[CourseModelToDB alloc]init];
    addModel.jie=indexPath.row+1;
    addModel.day=weekday;
    button.hidden=NO;
}
-(void) tableView:(UITableView *)tableView1 didDeselectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSLog(@"row=%d",indexPath.row);
    DayTableViewCell *cell=(DayTableViewCell*)[tableView1 cellForRowAtIndexPath:indexPath];
    UIButton *button=(UIButton*)[cell viewWithTag:155];
    //NSLog(@"button=%@",button);
    button.hidden=YES;
    
}

//添加课程
-(void) addCourse:(UIButton*) button
{
    AddCourseController *contr=[[AddCourseController alloc]init];
    //设置为编辑模式
    contr.editOrmodify=Eidt;
    contr.model=addModel;
    [self.delegate gotoDetailed:contr];
}

#pragma 通知到来是执行的方法
-(void) refreshData:(NSNotification*) notifition
{
    CourseDBService *service=[[CourseDBService alloc]init];
    NSLog(@"表名为=%@",(NSString*)notifition.object);
    _allCourse=[service findAllCourse:(NSString*)notifition.object];
    NSDictionary *result=[notifition userInfo];
    CourseModelToDB *model=[result objectForKey:@"addModel"];
    tableData=[self getModels:model.day];
    [tableView reloadData]; 
}
@end
