//
//  SelectProfessionController.m
//  SuperKb
//
//  Created by weili on 14-9-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "SelectProfessionController.h"
#import "ProfessionalController.h"
#import "SelectDepartmentCell.h"
#import "ARLabel.h"
#import "ThirdPostRequest.h"
#import "ShareTool.h"
#import "CouModel.h"
#import "CourseConvert.h"
#import "MBProgressHUD.h"
@interface SelectProfessionController() {
@private
    UITableView *table;
    MBProgressHUD *progress;
    NSArray *allTableName;
    CourseRecord *record;
    CourseConvert *convert;
    ThirdPostRequest *request;
}
@end

@implementation SelectProfessionController
@synthesize professions=_professions;
@synthesize profession=_profession;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.navigationItem.title=@"选着专业第二步";
        UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        rightButton.titleLabel.font= [UIFont systemFontOfSize:15];        [rightButton addTarget:self action:@selector(sendThridPost:) forControlEvents:UIControlEventTouchUpInside];
        [rightButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        [rightButton setTitle:@"继续" forState:UIControlStateNormal];
        UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithCustomView:rightButton];
        self.navigationItem.rightBarButtonItem=right;
        
        UIButton *leftButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        leftButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [leftButton addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];        
        [leftButton setTitle:@"返回" forState:UIControlStateNormal];
        UIBarButtonItem *left=[[UIBarButtonItem alloc]initWithCustomView:leftButton];
        self.navigationItem.leftBarButtonItem=left;
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
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getProffi:) name:@"profession" object:nil];   
    table=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 70)];
    table.dataSource=self;
    table.delegate=self;
    allTableName=[NSArray arrayWithObjects:@"first",@"second",@"thrid",@"fourth",@"fivth", nil];
    [self.view addSubview:table];
    

    
}


#pragma table delegate
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SelectDepartmentCell *cell=[[SelectDepartmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.frame=CGRectMake(0, 0, 320, 40);
    //cell.label.text=@"班级";
    cell.textLabel.text=_profession;
    cell.label.text=@"班级";
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
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

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section==0)
    {
        ProfessionalController *profession=[[ProfessionalController alloc]init];
        profession.professions=_professions;
        [self.navigationController pushViewController:profession animated:YES];
        
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma 接收通知的，执行的方法
-(void)getProffi:(NSNotification*) notifition
{
    NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:0];
    SelectDepartmentCell *cell=(SelectDepartmentCell*)[table cellForRowAtIndexPath:path];
     cell.textLabel.text=(NSString*) notifition.object;
}
#pragma  继续按钮点击方法
-(void) sendThridPost:(UIButton*) button
{
    //进行请求之前先判断记录是否已经存在
    CourseRecord *exit=[ShareTool shareInstance].tableRecord;
    record=[[CourseRecord alloc]init];
    record.year=exit.year;
    record.professional=exit.professional;
    record.term=exit.term;
    RecordService *service=[RecordService shareInstance];
    //判断当前的表是否已经存在
    if([service recordHasExist:record]==nil)
    {
        //决定表名
        if([service getTables]<=5)
        {
        record.tableName=[allTableName objectAtIndex:[service getTables]];
        }else{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示消息" message:@"添加课表数已满" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:nil, nil];
            [alert show];
  
        }
        
        //进行网络请求
        request=[[ThirdPostRequest alloc]init];
        request.mesDelegate=self;
        [request getCourse:[ShareTool shareInstance].changeArrri];
        progress=[[MBProgressHUD alloc]initWithView:self.view];
        progress.frame=CGRectMake(100, 100, 100, 80);
        //progress.detailsLabelFont=[UIFont systemFontOfSize:9];
        progress.labelFont=[UIFont systemFontOfSize:9];
        //progress.detailsLabelText=@"正在获取信息";
        progress.labelText=@"正在获取信息";
        [progress show:YES];
        [self.view addSubview:progress];        
        
    }else
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示消息" message:@"课表已经存在" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];
        //发出通知
        [[NSNotificationCenter defaultCenter] postNotificationName:@"display" object:record.tableName userInfo:nil];
        
    }
}

-(void) sendMess:(NSMutableDictionary *)course
{
    BOOL flag=NO;
    NSMutableArray *array=nil;
    //隐藏progress
    [progress hide:YES];
    
    for(NSString *week in course.allKeys)
    {
        array=[NSMutableArray array];
        
        NSLog(@"week=%@,",week);
        for(CouModel *model in [course objectForKey:week])
        {
            if(model.hasClass==0){
                flag=YES;
            }
            NSLog(@"name=%@",model.nameAndTea);
        }
    }
    RecordService *service=[RecordService shareInstance];
    if(flag)
    {
        [service insertRecord:record];
    }
    NSString *tableName=[service getlastTable];
    if(!flag)
    {
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"提示消息" message:@"没有查询到课表信息" delegate:nil cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show]; 
    
    }
    //[alert dismissWithClickedButtonIndex:1 animated:YES];
    //存储数据
    if(flag&&tableName){
        convert=[[CourseConvert alloc]initWithTableName:tableName];
        NSLog(@"course---------------%@",course);
        [convert convertFromDic:course];        
        UIAlertView *alert=[[UIAlertView alloc]initWithTitle:@"请求成功" message:@"点击确认返回" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确认", nil];
        [alert show];        
    
        //使用通知来完成数据的展示
        [[NSNotificationCenter defaultCenter] postNotificationName:@"display" object:tableName userInfo:nil];
    }
    
    
}
#pragma 返回上一层
-(void) back:(UIButton*) button
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma alert delegate
-(void)  alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex==1)
    {
        [self.navigationController popToRootViewControllerAnimated:YES];
    }
}
@end
