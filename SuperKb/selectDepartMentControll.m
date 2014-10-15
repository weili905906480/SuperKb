//
//  selectDepartMentControll.m
//  SuperKb
//
//  Created by weili on 14-9-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "selectDepartMentControll.h"
#import "ARLabel.h"
#import "SelectDepartmentCell.h"
#import "DepartmentController.h"
#import "ShareTool.h"
#import "SelectProfessionController.h"
#import "MBProgressHUD.h"
@interface selectDepartMentControll(){
@private
    BOOL flag;
    NSArray *year;
    NSString *selectyear;
    NSString *selectTerm;
    //NSString *term;
    //第一次get请求
    MBProgressHUD *progress;
    //第二次post请求
    MBProgressHUD *progress1;
}
@end

@implementation selectDepartMentControll
@synthesize tableView=_tableView;
@synthesize results=_results;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hidesBottomBarWhenPushed=YES;
        ARLabel *title=[[ARLabel alloc]initWithFrame:CGRectMake(0, 0, 150, 30)];
        title.text=@"获取课程表 第一步";
        title.textColor=[UIColor blackColor];
        self.navigationItem.titleView=title;
        UIButton *rightButton=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        rightButton.titleLabel.font=[UIFont systemFontOfSize:15];
        [rightButton addTarget:self action:@selector(sendSecondPost:) forControlEvents:UIControlEventTouchUpInside];
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

#pragma 第一次网络请求完成的代理方法
-(void) passDepart:(NSDictionary*) dic
{
    //加载页面
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 150)];
    _tableView.dataSource=self;
    _tableView.delegate=self;
    
    self.tableView.scrollEnabled=NO;
    //self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    //self.tableView.frame=CGRectMake(0, 0, 320, 200);
    [progress hide:YES];
    _results=dic;
    [self.view addSubview:_tableView];
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
    
   // kIOS7;
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeDepartment:) name:@"department" object:nil];
    
    year=[[NSArray alloc]initWithObjects:@"2011-2012",@"2012-2013",@"2013-2014",@"2014-2015",@"2015-2016",@"2016-2017", nil];
    //在这里进行第一次网络请求
    FirstGetRequest *getRequest=[[FirstGetRequest alloc]initGetRequest];
    getRequest.departmentDegelate=self;
    
    progress=[[MBProgressHUD alloc]initWithView:self.view];
    progress.frame=CGRectMake(100, 100, 100, 80);
    //progress.detailsLabelFont=[UIFont systemFontOfSize:9];
    progress.labelFont=[UIFont systemFontOfSize:9];
    //progress.detailsLabelText=@"正在获取信息";
    progress.labelText=@"正在获取信息";
    [progress show:YES];
    [self.view addSubview:progress];
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
   SelectDepartmentCell *cell=[[SelectDepartmentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    if(indexPath.section==0){
    
    cell.label.text=@"学期";
    cell.textLabel.text=@"2013学年";
    }else{
       cell.label.text=@"院系";
        cell.textLabel.text=@"选择专业";
    }
    cell.accessoryType=UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if(section==0)
    {
        return 20;
    }
    return 5;
}

-(UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    ARLabel *label;
    if(section==0)
    {
    label=[[ARLabel alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
        //label.backgroundColor=[UIColor redColor];
        label.textAlignment=UITextAlignmentCenter;
    label.text=@"将从考务系统导入课表";
    }
    return label;
}
-(void)changeDepartment:(NSNotification*) notfition
{
    NSString *text=notfition.object;
    NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:1];
    SelectDepartmentCell *cell=(SelectDepartmentCell*)[_tableView cellForRowAtIndexPath:path];
    cell.textLabel.text=text;
}
#pragma mark - Table view delegate
//跳转到选择department的控制器
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section==1)
    {
        DepartmentController *department=[[DepartmentController alloc]init];
        department.departments=_results;
        [self.navigationController pushViewController:department animated:YES];
        //请求网络得到数据
    }else{
        UIControl *backView=nil;
        UIView *selectYear=nil;
        if(!flag)
        {
            backView=(UIControl*)[self.view viewWithTag:106];
            if(backView==nil)
            {
                backView=[[UIControl alloc]initWithFrame:self.view.bounds];
                backView.backgroundColor=[UIColor blackColor];
                backView.alpha=0.6;
                backView.tag=106;
                [backView addTarget:self action:@selector(displayView:) forControlEvents:UIControlEventTouchUpInside];
                [self.view addSubview:backView];
            }
            backView.hidden=NO;
            selectYear=[self.view viewWithTag:107];
            if(selectYear==nil)
            {
                selectYear=[[UIView alloc]initWithFrame:CGRectMake(0, 220, 320, 260)];
                selectYear.backgroundColor=[UIColor whiteColor];
                selectYear.tag=107;
                
                //添加一个UIPickView
                UIPickerView *pickView=[[UIPickerView alloc]initWithFrame:CGRectMake(0, 40, 320, 150)];
                pickView.delegate=self;
                pickView.dataSource=self;
                pickView.showsSelectionIndicator=YES;
                [selectYear addSubview:pickView];
                UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(280, 10, 30, 20)];
                [button setTitle:@"确认" forState:UIControlStateNormal];
                [button addTarget:self action:@selector(storeYearAndTerm:) forControlEvents:UIControlEventTouchUpInside];
                button.titleLabel.font=[UIFont systemFontOfSize:14];
                [button setTitleColor:[UIColor blueColor]  forState:UIControlStateNormal];
                [selectYear addSubview:button];
                ARLabel *label=[[ARLabel alloc]initWithFrame:CGRectMake(30, 10, 250, 30)];
                label.textColor=[UIColor blackColor];
                label.text=@"请选择学年学期";
                label.textAlignment=UITextAlignmentCenter;
                [selectYear addSubview:label];
                [self.view addSubview:selectYear];
            }
            selectYear.hidden=NO;
            flag=YES;
        }
        
    }
}
#pragma leftButton 返回上一个界面
-(void) back:(UIButton*) button
{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma 显示底下的view
-(void) displayView:(UIControl*) contro
{
    if(flag)
    {
        UIControl *control=(UIControl*)[self.view viewWithTag:106];
        control.hidden=YES;
        UIView *view=(UIView*) [self.view viewWithTag:107];
        view.hidden=YES;
        flag=NO;
    }
}

#pragma pickView delegate and dataSource

-(NSInteger) numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 2;
}

-(NSInteger) pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if(component==0)
    {
        return 6;
    }else{
        return 2;
    }
}
-(NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    NSString *result=nil;
    if(component==1)
    {
        if(row==0)
        {
            result=@"上学期"; 
        }else{
            result=@"下学期";
        }
    }else{
    result=[year objectAtIndex:row];
    }
    return result;
}
-(void)  pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if(component==0)
    selectyear=[year objectAtIndex:row];
    NSLog(@"year=%@",selectyear);
    if(component==1)
    selectTerm=[NSString stringWithFormat:@"%d",row];
}
-(void) storeYearAndTerm:(UIButton*) button
{  
    
    NSArray *range=[selectyear componentsSeparatedByString:@"-"];
    NSString *year1=[range objectAtIndex:0];
    NSDictionary *dic=[ShareTool shareInstance].changeArrri;
     CourseRecord *record=[ShareTool shareInstance].tableRecord;    
    [dic setValue:year1 forKey:@"year"];
    record.year=year1;
    if(selectTerm==nil){
        selectTerm=@"1";
    }
    record.term=selectTerm;
    [dic setValue:selectTerm forKey:@"term"];
    NSLog(@"count=%d",[ShareTool shareInstance].changeArrri.allKeys.count);
    if(flag)
    {
        UIControl *control=(UIControl*)[self.view viewWithTag:106];
        control.hidden=YES;
        UIView *view=(UIView*) [self.view viewWithTag:107];
        view.hidden=YES;
        
        //改变cell的值
        NSIndexPath *path=[NSIndexPath indexPathForRow:0 inSection:0];
        
        SelectDepartmentCell *cell=(SelectDepartmentCell*)[_tableView cellForRowAtIndexPath:path];
        NSString *term=[NSString stringWithFormat:@"%d",selectTerm.intValue+1];
        cell.textLabel.text=[selectyear stringByAppendingFormat:@"(第%@学期)",term];
        flag=NO; 
    }
 
}

#pragma 发送第二次请求
-(void) sendSecondPost:(UIButton*) button
{
    SecondPostRequest *request=[[SecondPostRequest alloc]init];
    request.proDelegate=self;
    
    progress1=[[MBProgressHUD alloc]initWithView:self.view];
    progress1.frame=CGRectMake(100, 100, 100, 80);
    progress1.labelFont=[UIFont systemFontOfSize:9];
    //progress.detailsLabelText=@"正在获取信息";
    progress1.labelText=@"正在获取信息";
    
    [progress1 show:YES];    //NSLog(@"数组元素=%d",[ShareTool shareInstance].changeArrri.allKeys.count);
    
    [self.view addSubview:progress1];
    for(NSString *key in [ShareTool shareInstance].changeArrri.allKeys)
    {
        NSLog(@"数组元素=%@", [[ShareTool shareInstance].changeArrri objectForKey:key]);
    }
    [request getProfessional:[ShareTool shareInstance].changeArrri];
}

#pragma sendProfessional 代理
-(void) sendPro:(NSMutableDictionary *)dictionary
{
    //页面跳转
    [progress1 hide:YES];
    for(NSString *key in dictionary.allKeys)
    {
        NSLog(@"班级=%@",[dictionary objectForKey:key]);
    }
    SelectProfessionController *contro=[[SelectProfessionController alloc]init];
    contro.professions=dictionary;
    [self.navigationController pushViewController:contro animated:YES];
    
}
@end
