//
//  SelectTNoteType.m
//  SuperKb
//
//  Created by weili on 14-10-4.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "SelectTNoteType.h"
#import "DisplayCourse.h"
@interface SelectTNoteType()
{
    NSArray *_noteType;
}


@end


@implementation SelectTNoteType
@synthesize courseName=_courseName;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.title=@"选择分类";
    }
    return self;
}

-(void) viewDidLoad
{
    UITableView *myTableView=[[UITableView alloc]initWithFrame:self.view.bounds style:UITableViewStyleGrouped];
    
    myTableView.dataSource=self;
    myTableView.delegate=self;
    [self.view addSubview:myTableView];
    _noteType=[[NSArray alloc]initWithObjects:@"默认",@"作业",@"笔记",@"事务", nil];
    
}

-(NSInteger) numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
-(NSInteger) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    cell.textLabel.text=[_noteType objectAtIndex:indexPath.row];
    
    return cell;
}

-(void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell=[tableView cellForRowAtIndexPath:indexPath];
    
    if(indexPath.row==1||indexPath.row==2)
    {
        DisplayCourse *control=[[DisplayCourse alloc]init];
        [self.navigationController pushViewController:control animated:YES];
    }else
    {
        [self.navigationController popViewControllerAnimated:YES];
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:@"noteType" object:cell.textLabel.text userInfo:nil];
}
@end
