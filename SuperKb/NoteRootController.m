//
//  NoteRootController.m
//  SuperKb
//
//  Created by weili on 14-9-30.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "NoteRootController.h"
#import "NoteCell.h"
#import "NoteModel.h"
#import "NoteService.h"
@interface NoteRootController()  {
@private
    NSString *alertMessage;
    UITableView *myTable;
    CGFloat tableHeight;
    NoteModel *alert;
    NSIndexPath *path;
}
-(void) createToolBar;
-(void) createNavigationItem;
-(void) createTableView;
@end
@implementation NoteRootController
@synthesize notes=_notes;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
}

-(void) createNavigationItem
{
    UIButton *right=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
    [right addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
    [right setBackgroundImage:[UIImage imageNamed:@"ic_navigation_back_normal"] forState:UIControlStateNormal];
    [right setBackgroundImage:[UIImage imageNamed:@"ic_navigation_back_pressed"] forState:UIControlStateSelected];
    UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:right];
    self.navigationItem.leftBarButtonItem=leftButton;
    self.title=@"烂笔头";
}
//创建一个工具条
-(void) createToolBar
{
    UIView *view =[[UIView alloc]initWithFrame:CGRectMake(0, 376, 320, 40)];
    UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
    image.image=[UIImage imageNamed:@"line"];
    [view addSubview:image];
    
    UIButton *newCreate=[[UIButton alloc]initWithFrame:CGRectMake(80, 0, 30, 40)];
    [newCreate setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    newCreate.titleLabel.font=[UIFont systemFontOfSize:12];
   [newCreate setImage:[UIImage imageNamed:@"ic_note_text_icon2"] forState:UIControlStateNormal];    
   // [newCreate setBackgroundImage:[UIImage imageNamed:@"ic_note_text_icon2"] forState:UIControlStateNormal];
    UILabel *label=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, 30, 15)];
    label.font=[UIFont systemFontOfSize:12];
    label.textColor=[UIColor blueColor];
    label.text=@"新建";
    label.textAlignment=UITextAlignmentCenter;
    [newCreate addSubview:label];
    [newCreate addTarget:self action:@selector(newBuild:) forControlEvents:UIControlEventTouchUpInside];
    [newCreate setTitle:@"新建" forState:UIControlStateNormal];
    //[newCreate setTitleEdgeInsets:UIEdgeInsetsMake(20, 0, 0, 0)];

    
    [newCreate setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 15, 0)];  
    [view addSubview:newCreate];
    
    UIButton *refeshButton=[[UIButton alloc]initWithFrame:CGRectMake(210, 0, 30, 40)];
    [refeshButton setImage:[UIImage imageNamed:@"ic_note_sync_clond_icon4.jpg"] forState:UIControlStateNormal];
    [refeshButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
    [refeshButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 13, 0)];
    
    //[refeshButton setTitle:@"刷新" forState:UIControlStateNormal];
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(0, 25, 30, 15)];
    label1.font=[UIFont systemFontOfSize:12];
    label1.textColor=[UIColor blueColor];
    label1.text=@"刷新";
    label1.textAlignment=UITextAlignmentCenter;
    [refeshButton addSubview:label1];
    refeshButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [view addSubview:refeshButton];
    
   
    [self.view addSubview:view];
}
#pragma mark - View lifecycle
-(void) back:(UIButton*) button
{
    [self.navigationController popViewControllerAnimated:YES];
    //在这里添加数据
    NoteService *service=[NoteService shareIntance];
    if ([service StoreToFile])
        NSLog(@"保存成功");    
}

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createNavigationItem];
    [self createToolBar];
    [self createTableView];
    NSDate *date=[NSDate date];
    NSString *title=@"功能介绍";
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    [formatter setDateFormat:@"hh-mm"];
    NSString *str=[formatter stringFromDate:date];
    NSString *result=@"哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈哈";
    alertMessage=result;
    alert=[[NoteModel alloc]init];
    alert.title=title;
   alert.time=str;
    alert.yearAndmonth=@"2014-9-30";
    alert.detailMessage=result;
    
    
    NoteService *service=[NoteService shareIntance];
    _notes=[service allNotes];
    
    
    
}

-(void) createTableView
{
    myTable=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320,376) style:UITableViewStylePlain];
    myTable.separatorStyle=UITableViewCellSeparatorStyleNone;
    myTable.delegate=self;
    myTable.dataSource=self;
    [self.view addSubview:myTable];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) newBuild:(UIButton*) button
{
    NoteMesController *control=[[NoteMesController alloc]init];
    control.noteDelegate=self;
    [self.navigationController pushViewController:control animated:YES];
}

#pragma tableView delegate 
-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return _notes.count+1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSMutableArray *dayNotes;
    if(section==_notes.count)
    {
        return 1;  
    }else{
        dayNotes=[_notes objectAtIndex:section];
    }
    return dayNotes.count;
}
-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NoteCell *cell=[[NoteCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];

    
    if(indexPath.section==_notes.count)
    {
        cell.label.text=alert.title;
        [cell  noteContent:[alert.time stringByAppendingFormat:@" %@",alert.detailMessage]];
        cell.selectionStyle=UITableViewCellSelectionStyleNone;
        
    }else{
        NSMutableArray *models=[_notes objectAtIndex:indexPath.section];
        NoteModel *model=[models objectAtIndex:indexPath.row];
        cell.label.text=model.title;
        NSString *detail=[model.time stringByAppendingFormat:@" %@",model.detailMessage];
        [cell noteContent:detail];
        
    }
    //cell.label2.text=str;
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    CGFloat sectionHeight=20;
    tableHeight+=sectionHeight;
    return sectionHeight;
}
-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{  
    NSString *result;
    if(section==_notes.count)
   {
       result=alert.yearAndmonth;
   }else{
    
    NSMutableArray *arr=[_notes objectAtIndex:section];
    NoteModel *model=[arr lastObject];
       result=model.yearAndmonth;   
   }
    return result;
}

//根据内容设置动态的高度
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat cellheight;
    NSMutableArray *arr;
    NoteModel *model;
    if(_notes.count==indexPath.section){
        model=alert;
    }else{
        arr=[_notes objectAtIndex:indexPath.section];
        model=[arr objectAtIndex:indexPath.row];
    }
      
    NSString *text=model.detailMessage;
    NSLog(@"text=%@",text);
    CGSize constraint=CGSizeMake(200, 1000);
    CGSize size=[text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    if(size.width>190)
    {
        cellheight=80.0;
    }else
    {
        cellheight=50;
    }
    tableHeight+=cellheight;
    //myTable.frame=CGRectMake(0, 0, 320, tableHeight);
    return cellheight;
}

#pragma note insert delegate
-(void) addNote:(NoteModel *)model isModify:(BOOL)flag
{
    NoteService *service=[NoteService shareIntance];
    if(!flag){
    _notes=[service storeNotes:model];
    }else
    {
        _notes=[service modifyNote:model andIndex:path];
    }
    [myTable reloadData];
}


//选中之后的修改
-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    if(indexPath.section==_notes.count)
    {
        return;
    }
    NoteModel *model=[[_notes objectAtIndex:indexPath.section] objectAtIndex:indexPath.row];
    path=indexPath;
    NoteMesController *contro=[[NoteMesController alloc]init];
    contro.noteDelegate=self;
    contro.edit=model;
    [self.navigationController pushViewController:contro animated:YES];
    
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
