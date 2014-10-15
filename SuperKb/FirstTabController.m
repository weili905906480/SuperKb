//
//  FirstTabController.m
//  SuperKb
//
//  Created by weili on 14-9-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "FirstTabController.h"

#import "RecordService.h"
#import "DetailedCourseController.h"
#import "WEPopoverController.h"
#import "WeeksController.h"
#import "AddCourseController.h"
#import "MBProgressHUD.h"
#import "ModifyCurrentWeek.h"
@interface FirstTabController () {
@private
    BOOL popover;
    WeeksController *controller;
    DayController *dayController;
    
    //创建一个
    MBProgressHUD *progress;
    RecordService *recordservice;
    
    BOOL weekOrDay;
}
-(NSInteger) getCurrentWeek;

-(void) changeCurrentWeek;
@end

@implementation FirstTabController
@synthesize tableView=_tableView;
@synthesize datasource=_datasource;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 30, 30)];
        //[button setBackgroundColor:[UIColor redColor]];
        //[button setTitle:@"+" forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageNamed:@"ic_title_add_icon"] forState:UIControlStateNormal];
        
        [button setBackgroundImage:[UIImage imageNamed:@"ic_title_add_icon_pressed"] forState:UIControlStateSelected];
        button.titleLabel.font=[UIFont systemFontOfSize:20];
        button.tag=105;
        [button addTarget:self action:@selector(addCourse:) forControlEvents:UIControlEventTouchUpInside];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        UIBarButtonItem *rightItem=[[UIBarButtonItem alloc]initWithCustomView:button];
        self.navigationItem.rightBarButtonItem=rightItem;
        
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"ic_tabbar_cou_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_tabbar_cou_normal"]];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor
       blackColor],UITextAttributeTextColor,[UIFont systemFontOfSize:12],UITextAttributeFont, nil];
        NSDictionary *select=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.0431 green:0.6588 blue:1.0000 alpha:1], UITextAttributeTextColor,nil];
        
        self.title=@"课程表";
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


- (void)viewDidLoad
{
    [super viewDidLoad];
    //数据从数据库中得到
    NSUserDefaults *def=[NSUserDefaults standardUserDefaults];
    
    NSMutableArray *user=[def objectForKey:@"userMessage"];
    
    recordservice=[RecordService shareInstance];
    //[service storeLastTable:@"thrid"];
    NSString *tableName=[recordservice getlastTable];
    
    if(tableName){
        NSLog(@"tableName=%@",tableName);
        CourseDBService *service=[[CourseDBService alloc]init];
        array=[service findAllCourse:tableName];
        ShareTool *tool=[ShareTool shareInstance];
        tool.courseName=[NSMutableArray arrayWithArray:array];       
    } else{
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"小提示" message:@"还没有添加课表,点击确定添加" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
        [alert show];
    
    }
    
    dayController=[[DayController alloc]init];
    //[self presentModalViewController:dayController animated:YES];
     dayController.allCourse=array;//给表格传值,所以当给controller传值的时候，应该在使用它的view之前
    //这里要注意当control开始使用到view时，这个时候就会调用view的生命周期函数
    dayController.view.tag=140;
    dayController.delegate=self;
    dayController.view.frame=CGRectMake(0, 0, 320, 460);
    UIView *view=[self.view viewWithTag:140];
    if(view==nil){
        [self.view addSubview:dayController.view]; 
    }    
    
    
    UIButton *titleView=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 130, 40)];
    [titleView setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    
    
    [titleView setTitle:[user objectAtIndex:1] forState:UIControlStateNormal];
    [titleView addTarget:self action:@selector(modifyWeek:) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.titleView=titleView;    
    
    UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 50, 40)];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(3, 10, 15, 30)];
    label1.text=@"日";
    label1.tag=170;
    label1.textColor=[UIColor blueColor];
    label1.font=[UIFont systemFontOfSize:12];
    ARLabel *label2=[[ARLabel alloc]initWithFrame:CGRectMake(20, 10, 5, 30)];
    label2.text=@"/";
    label2.textColor=[UIColor blueColor];
    UILabel *label3=[[UILabel alloc]initWithFrame:CGRectMake(26, 10, 15, 30)];
    label3.font=[UIFont systemFontOfSize:16];
    label3.text=@"周";
    label3.tag=171;
    label3.textColor=[UIColor blueColor];
    
    [leftButton addSubview:label1];
    [leftButton addSubview:label2];
    [leftButton addSubview:label3];
    //[leftButton setTitle:@"日/周" forState:UIControlStateNormal];
    [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [leftButton addTarget:self action:@selector(dayControl:) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem=left;
    //创建数据库表
    //CourseDBService *service=[[CourseDBService alloc]initWithTable:@"first"];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(disPlayCourse:) name:@"display" object:nil];
    _tableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.scrollEnabled=NO;
    _tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    NSDate *date=[NSDate date];
    //获取当前日历
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *comps=nil;
    //获取当前的星期
    comps=[calendar components:NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:date];
    int weekday1=[comps weekday];
    int day1=[comps day];
     NSLog(@"星期=%d,号%d",weekday1,day1);
    NSDateFormatter *formater=[[NSDateFormatter alloc]init];
    [formater setDateFormat:@"MM"];
    int mon=[[formater  stringFromDate:date] intValue] ;
    NSString *monthStr=[NSString stringWithFormat:@"%d月",mon];
    //创建一个头部视图
    ARLabel *month=[[ARLabel alloc]initWithFrame:CGRectMake(0, 0, 20, 40)];
    month.text=monthStr;
    UIView *tableHeader=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
   
    [tableHeader addSubview:month];
    
    /*NSDate *date2=[NSDate dateWithTimeInterval:24*60*60 sinceDate:date];    
    comps=[calendar components:NSWeekdayCalendarUnit|NSDayCalendarUnit fromDate:date2];
    int weekday2=[comps weekday];
    int day2=[comps day]; */
    //NSLog(@"明天星期=%d,号%d",weekday2,day2);    
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
        
        ARLabel *label=[[ARLabel alloc]initWithFrame:CGRectMake(20+i*43, 0, 43, 40)];
        label.numberOfLines=0;
        if(weekday==1)
        {
            label.text=[NSString stringWithFormat:@"  %d\n星期%d",day-6+i, i+1];
        }else{
           label.text=[NSString stringWithFormat:@"  %d\n星期%d",day-weekday+2+i ,i+1];
        }

        label.textColor=[UIColor blackColor];
        [_tableView addSubview:label];
    }
    
    _tableView.tableHeaderView=tableHeader;

}


- (void)viewDidUnload
{
    [super viewDidUnload];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) sendMess:(NSMutableDictionary *)course
{
    for(NSString *week in course.allKeys)
    {
        NSLog(@"week=%@",week);
        //NSLog(@"day=%@",[result objectForKey:week]);
        array=[NSMutableArray array];
        for(CouModel *model in [course objectForKey:week])
        {
            NSLog(@"model=%@",model);
            
        }
    }
}
#pragma addCourse:,添加按钮
-(void) addCourse:(UIButton*) button
{
    UIView *otherView=nil;
    UIControl *backView=nil;
    if(!flag){
        
        //这里需要注意的是观察view是否还存在
        backView=(UIControl*)[self.view viewWithTag:104];
        if(backView==nil){
            backView=[[UIControl alloc]initWithFrame:self.view.bounds];
            [backView setBackgroundColor:[UIColor blackColor]];
            backView.alpha=0.6;
            backView.tag=104;
            [backView addTarget:self action:@selector(cancle:) forControlEvents:UIControlEventTouchUpInside]; 
            [self.view addSubview:backView];
        }
        
        otherView =[self.view viewWithTag:103];
        if (otherView==nil){
    otherView=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 100)];
    [otherView setBackgroundColor:[UIColor whiteColor]];
      [self.view addSubview:otherView];
        otherView.tag=103;
            //添加按钮
            UIButton *addCourse=[[UIButton alloc]initWithFrame:CGRectMake(240, 50, 40, 30)];
            //addCourse.backgroundColor=[UIColor redColor];
            [addCourse setTitle:@"添加课程" forState:UIControlStateNormal];
            addCourse.titleLabel.font=[UIFont systemFontOfSize:10];
            [addCourse addTarget:self action:@selector(selectDepartment:) forControlEvents:UIControlEventTouchUpInside];
            [addCourse setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
            [otherView addSubview:addCourse];
            
        }
        otherView.hidden=NO;
        backView.hidden=NO;
    [UIView beginAnimations:nil context:nil];
    button.imageView.transform=CGAffineTransformMakeRotation(M_PI_4);
    [UIView commitAnimations];
        flag=YES;
    }else
    {
        [UIView beginAnimations:nil context:nil];
        //button.selected=NO;
        //button.transform=CGAffineTransformMakeRotation(M_2_PI-M_PI_4);
        otherView=[self.view viewWithTag:103];
        backView=(UIControl*)[self.view viewWithTag:104];
        [UIView commitAnimations];
        otherView.hidden=YES;
        backView.hidden=YES;
        [UIView commitAnimations];
        flag=NO;
    }
}
-(void) cancle:(UIControl*) cont
{
    if(flag){
    [UIView beginAnimations:nil context:nil];
    UIButton *button=(UIButton*)[self.view viewWithTag:105];
    button.transform=CGAffineTransformMakeRotation(M_2_PI-M_PI_4);
    [UIView commitAnimations];
    UIView *otherView=[self.view viewWithTag:103];
    otherView.hidden=YES;
    UIControl *contro=(UIControl*)[self.view viewWithTag:104];
    contro.hidden=YES;
        flag=NO;
    }
}
#pragma selectDepartment://选择院系页面跳转
-(void)selectDepartment:(UIButton*) button
{
    selectDepartMentControll *department=[[selectDepartMentControll alloc]init];
    [self.navigationController pushViewController:department animated:YES];
    
    //隐藏view
    if(flag){
        [UIView beginAnimations:nil context:nil];
        UIButton *button=(UIButton*)[self.view viewWithTag:105];
        button.transform=CGAffineTransformMakeRotation(M_2_PI-M_PI_4);
        [UIView commitAnimations];
        UIView *otherView=[self.view viewWithTag:103];
        otherView.hidden=YES;
        UIControl *contro=(UIControl*)[self.view viewWithTag:104];
        contro.hidden=YES;
        flag=NO;
    }    
}

#pragma 通知到来时执行的方法,通知具有多对多的方便的功能
-(void)disPlayCourse:(NSNotification*) notifition
{
    CourseDBService *service=[[CourseDBService alloc]init];
    NSLog(@"表名为=%@",(NSString*)notifition.object);
    array=[service findAllCourse:(NSString*)notifition.object];
    [_tableView reloadData];
}

#pragma tableView delegate

-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    DisplayCoursecell *cell=[[DisplayCoursecell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    UIButton *button=nil;
    
    cell.label.text=[NSString stringWithFormat:@"%d",indexPath.row+1];
   
        
    for(int i=0;i<array.count;i++){
        CourseModelToDB *model=[array objectAtIndex:i];
        
        if(indexPath.row==model.jie-1){
            button=(UIButton*)[cell viewWithTag:111+model.day-1];
            [button  addTarget:self action:@selector(detailControl:) forControlEvents:UIControlEventTouchUpInside];
            //NSString *weekRes=[NSString stringWithFormat:@"%@(非本周)",model.courseName];
            
            [button setTitle:model.courseName forState:UIControlStateNormal];
        }
    }  
    
    return cell;
}
//点击某个按钮,跳转到详细信息的页面
-(void) detailControl:(UIButton*) button
{
    DisplayCoursecell *view=(DisplayCoursecell*)[[button superview] superview];
    NSIndexPath *path=[_tableView indexPathForCell:view];
    int jie=path.row+1;
    int day=button.tag-110;
    for (CourseModelToDB *model in array) {
        if(jie==model.jie&&day==model.day)
        {
            DetailedCourseController *contro=[[DetailedCourseController alloc]init];
            contro.courseName=button.titleLabel.text;
            contro.res=model;
            [self.navigationController pushViewController:contro animated:YES];
            return;
        }
    }
}
-(void)modifyWeek:(UIButton*) button
{
    UIControl *contr=(UIControl*)[self.tabBarController.view viewWithTag:130];
    UIImageView *imageView=(UIImageView*)[self.tabBarController.view viewWithTag:131];    
    UIView *view=[self.tabBarController.view viewWithTag:132];

    if(!popover){
    
    if (contr==nil) {
        contr=[[UIControl alloc]initWithFrame:CGRectMake(0, 20, 320, 460)];
        contr.backgroundColor=[UIColor blackColor];
        contr.alpha=0.05;
        contr.tag=130;
        [contr addTarget:self action:@selector(hidePopover:) forControlEvents:UIControlEventTouchUpInside];
        [self.tabBarController.view addSubview:contr];
    }
    if(imageView==nil)
    {
        imageView=[[UIImageView alloc]initWithFrame:CGRectMake(157, 64, 5, 5)];
        imageView.image=[UIImage imageNamed:@"popoverArrowUp"];
        imageView.tag=131;
        [self.tabBarController.view addSubview:imageView];
    }
        if(view==nil){
            view=[[UIView alloc]initWithFrame:CGRectMake(100, 69, 120, 180)];
            view.tag=132;
            view.backgroundColor=[UIColor whiteColor];
            
            UIButton *modifyButton=[UIButton buttonWithType:UIButtonTypeRoundedRect];
            modifyButton.frame=CGRectMake(2, 150, 116, 28);
            modifyButton.titleLabel.font=[UIFont systemFontOfSize:12];
            [modifyButton setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
            [modifyButton setTitle:@"修改当前周" forState:UIControlStateNormal];
            [modifyButton addTarget:self action:@selector(modifyCurrentWeek:) forControlEvents:UIControlEventTouchUpInside];
            [view addSubview:modifyButton];
            
            NSMutableArray *weeks=[[NSMutableArray alloc]init];
            
            
            //根据userdefault的值得到数据
            NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
            
            NSArray *weekAll=[defaults objectForKey:@"userMessage"];
            
            NSString *weekUser=[weekAll objectAtIndex:1];
            NSArray *arr=[weekUser componentsSeparatedByString:@"("];
            
            NSString *currentWeek=[arr objectAtIndex:0];
            for (int i=0; i<24; i++) {
                NSString *week=[NSString stringWithFormat:@"第%d周",i+1];
                if([currentWeek isEqualToString:week])
                {
                    [weeks addObject:weekUser];  
                }else{
                    [weeks addObject:week];
                }
            }
            
            
            controller=[[WeeksController alloc]init];
            controller.tableView.frame=CGRectMake(0, 0, 120, 150);
            controller.weekends=weeks;
            controller.delegateWeek=self;
            controller.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
            //UITableView *weeks=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 120, 150)];
            //weeks.
            [view addSubview:controller.tableView];
            [self.tabBarController.view addSubview:view];
        }
        contr.hidden=NO;
        imageView.hidden=NO;
        view.hidden=NO;
        popover=YES;
    }else{
        contr.hidden=YES;
        imageView.hidden=YES;
        view.hidden=YES;
        popover=NO;
    }
    
    
}
-(void)hidePopover:(UIControl*) contro
{
    UIControl *contr=(UIControl*)[self.tabBarController.view viewWithTag:130];
    UIImageView *imageView=(UIImageView*)[self.tabBarController.view viewWithTag:131];    
    UIView *view=[self.tabBarController.view viewWithTag:132];    
    contr.hidden=YES;
    imageView.hidden=YES;
    view.hidden=YES;
    popover=NO;
}
#pragma weekchange delegate method
-(void) changeWeek:(NSString *)week
{
    UIButton *titleView=(UIButton*)self.navigationItem.titleView;
    [titleView setTitle:week forState:UIControlStateNormal];
}

//跳转到带表格的课程表视图
-(void)dayControl:(UIButton*) button
{
    UILabel *week=(UILabel*)[button viewWithTag:170];
    //添加一个动画
    UILabel *day=(UILabel*)[button viewWithTag:171];

    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:0.5];
    /*if(weekOrDay)
    {
        week.font=[UIFont systemFontOfSize:12];
        day.font=[UIFont systemFontOfSize:16];
        weekOrDay=NO;
    }else{
        week.font=[UIFont systemFontOfSize:16];
        day.font=[UIFont systemFontOfSize:12];
        weekOrDay=YES;
    }*/
                   //[UIView setAnimationDelay:2];
    [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromLeft forView:self.view cache:NO];
    [self.view exchangeSubviewAtIndex:0 withSubviewAtIndex:1];
    
    [UIView commitAnimations];
    
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:1.5];
    if(weekOrDay)
    {
        week.font=[UIFont systemFontOfSize:12];
        day.font=[UIFont systemFontOfSize:16];
        weekOrDay=NO;
    }else{
        week.font=[UIFont systemFontOfSize:16];
        day.font=[UIFont systemFontOfSize:12];
        weekOrDay=YES;
    }
    [UIView commitAnimations];    
    
    
}
#pragma DayController的代理方法
-(void) gotoDetailed:(UIViewController *)contro
{
    [self.navigationController pushViewController:contro animated:YES];
}

#pragma mark 修改当前周
-(void) modifyCurrentWeek:(UIButton*) button
{
    ModifyCurrentWeek *control=[[ModifyCurrentWeek alloc]init]; 
    UIButton *but=(UIButton*) self.navigationItem.titleView;
    control.currentWeek=but.titleLabel.text;
    NSString *res =[[but.titleLabel.text componentsSeparatedByString:@"("] objectAtIndex:0];
    control.currentWeek=res;
    [self.navigationController pushViewController:control animated:YES];
    
    [self hidePopover:nil];
}

#pragma mark 得到今年当前的周数
-(NSInteger) getCurrentWeek
{
    NSDate *date=[NSDate date];
    NSCalendar *calendar=[NSCalendar currentCalendar];
    NSDateComponents *comps=nil;
    //获取当前的星期
    comps=[calendar components:NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit fromDate:date];
    int week=[comps week];
    return  week;
}


-(void)  alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        selectDepartMentControll *department=[[selectDepartMentControll alloc]init];
        [self.navigationController pushViewController:department animated:YES];
    }
}
@end


/*@implementation UITabBar (CustomImage2)   
- (void)drawRect:(CGRect)rect {   
    UIImage *image = [UIImage imageNamed: @"bar.png"];   
    [image drawInRect:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];   
}   
@end*/