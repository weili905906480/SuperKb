//
//  AddCourseController.m
//  SuperKb
//
//  Created by weili on 14-9-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "AddCourseController.h"
#import "CourseDBService.h"
#import "RecordService.h"
@implementation AddCourseController
@synthesize model=_model;
@synthesize editOrmodify=_editOrmodify;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
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
    
    UIBarButtonItem *right=[[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStylePlain  target:self action:@selector(storeModel:)];
    right.tintColor=[UIColor blueColor];
    self.navigationItem.rightBarButtonItem=right;
      
    UIButton *left=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [left addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [left setBackgroundImage:[UIImage imageNamed:@"ic_navigation_back_normal"] forState:UIControlStateNormal];
    [left setBackgroundImage:[UIImage imageNamed:@"ic_navigation_back_pressed"] forState:UIControlStateSelected];
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:left];
    self.navigationItem.leftBarButtonItem=leftButton;    
    
    // Do any additional setup after loading the view from its nib.
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

-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 10;
}
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section==0)
    {
        return 3;
    }else
    {
        return 2;
    }
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:nil];
    if(indexPath.section==0)
    {
        UITextField *field=[[UITextField alloc]initWithFrame:CGRectMake(70, 5, 200, 40)];
        field.tag=150+indexPath.row;
        field.delegate=self;
              
        
        if(indexPath.row==0)
        {
            if(_editOrmodify==Modify)
                field.text=_model.courseName;
            cell.textLabel.text=@"名称";
        }else if(indexPath.row==1)
        {
            if(_editOrmodify==Modify)
                field.text=_model.teacher;
            cell.textLabel.text=@"老师";
        }else{
            if(_editOrmodify==Modify)
                field.text=_model.classroom;
            cell.textLabel.text=@"教室";
        }

        [cell.contentView addSubview:field];
    }
    if(indexPath.section==1)
    {
        if(indexPath.row==0)
        {
         cell.textLabel.text=@"节数";
            cell.detailTextLabel.text=[NSString stringWithFormat:@"星期%d~第%d节",_model.day,_model.jie];
        }else
        {
            cell.textLabel.text=@"周数";
            if(_editOrmodify==Modify)
            {
                cell.detailTextLabel.text=_model.weekendLast;
            }
        }
         cell.accessoryType= UITableViewCellAccessoryDisclosureIndicator; 
    }

    return cell;
}


-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    
    [textField resignFirstResponder];
    return YES;
}

-(void) textFieldDidEndEditing:(UITextField *)textField
{
    NSLog(@"endEditing");
    if(textField.text!=nil){
    if(textField.tag==150)
    {
        _model.courseName=textField.text;
    }else if(textField.tag==151){
        _model.teacher=textField.text;
    }else if(textField.tag==152)
    {
        _model.classroom=textField.text;
    }
}
}

-(void)storeModel:(UIBarButtonItem*) button
{
    //进行存储操作
    CourseDBService *service=[[CourseDBService alloc]init];
    //NSLog(@"name=%@",_model.courseName);
    _model.classes=@"无";
    _model.weekendLast=@"1-13";
    NSString *tableName=[[RecordService shareInstance] getlastTable];
    
    if(_editOrmodify==Eidt)
    {
    if([service insertCourse:_model andTableName:tableName])
        {
            NSLog(@"插入成功");
        }
    }else if(_editOrmodify==Modify){
        
        CourseModelToDB *model1=[[CourseModelToDB alloc]init];
        model1.jie=_model.jie;
        model1.day=_model.day;
        model1.courseName=_model.courseName;
        model1.classes=_model.classes;
        model1.teacher=_model.teacher;
        model1.classroom=_model.classroom;
        model1.weekendLast=_model.weekendLast;
        NSLog(@"model=%@",model1);
        if([service modifyCourse:model1 fromCourse:_model tableName:tableName])
        {
            NSLog(@"修改成功");
        }
    }
    NSDictionary *diction=[[NSDictionary alloc]initWithObjectsAndKeys:_model,@"addModel", nil];
    [[NSNotificationCenter defaultCenter] postNotificationName:@"display" object:tableName userInfo:diction];
}

-(void) back:(UIButton*) button
{
    [self.navigationController popViewControllerAnimated:YES];
}
@end
