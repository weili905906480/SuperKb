//
//  QuestionController.m
//  SuperKb
//
//  Created by weili on 14-10-8.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "QuestionController.h"
#import "QuestionCell.h"
#import "QuestionModel.h"

@interface QuestionController () {
@private
    //QuestionModel *slectedModel;
    NSString *answer;
    NSInteger selectedRow;
    BOOL flag;
}
@property(nonatomic,strong) NSMutableArray *result;
@property(nonatomic,strong) NSMutableArray *display;
@end

@implementation QuestionController
@synthesize result=_result;
@synthesize display=_display;
- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
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

    _result=[NSMutableArray arrayWithCapacity:5];
    _display=[NSMutableArray array];
    for (int i=0; i<5; i++) {
        QuestionModel *model=[[QuestionModel alloc]init];
        model.flag=NO;
        model.question=@"为什么要创建学期才能导入课程表?";
        model.answer=@"每个学期对应只能有一张课表，创建学期才能导入对应的学期的课表,每个学期对应只能有一张课表，创建学期才能导入对应的学期的课表";
        [_result addObject:model];
        [_display addObject:model.question];
    }
    
    QuestionModel *model2=[[QuestionModel alloc]init];
    model2.flag=NO;
    model2.question=@"要怎么样才能导入多张课表";
    model2.answer=@"     (1)必须要选着对应的学期,然后选着对应的专业";
    [_result addObject:model2];
    [_display addObject:model2.question];
    selectedRow=-2;
}

- (void)viewDidUnload
{
    [super viewDidUnload];

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

    return _display.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    QuestionCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[QuestionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
        [cell textContent:[_display objectAtIndex:indexPath.row]] ;
    if(selectedRow==indexPath.row&&!flag) 
    {
        cell.view.image=[UIImage imageNamed:@"cell-selected"];
    }else{
        cell.view.image=[UIImage imageNamed:@"cell-diddelected"];   
    }
    
   if(selectedRow+1==indexPath.row)
   {
       cell.flag=YES;
   }else{
       cell.flag=NO;
   }
    if(flag)
    {
        cell.flag=NO;
    }
    cell.selectionStyle=UITableViewCellSelectionStyleNone;
    return cell;
}
-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CGSize size=CGSizeMake(300, 1000);
    NSString *str=[_display objectAtIndex:indexPath.row];
    CGSize textSize=[str sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    NSLog(@"text=%f",textSize.height);
    return textSize.height+20;
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
    QuestionModel *model;
    if(indexPath.row==_result.count){
      model =[_result objectAtIndex:indexPath.row-1];
    }else{
        model=[_result objectAtIndex:indexPath.row];
    }
    if(selectedRow==-2||flag)
    {
        [_display insertObject:model.answer atIndex:indexPath.row+1];
        selectedRow=indexPath.row;
        flag=NO;
    }else{
        if(selectedRow+1==indexPath.row)
        {
            return;
        }
        [_display removeObjectAtIndex:selectedRow+1];
               
        if(selectedRow!=indexPath.row)//如果选择的是同一个cell
        {
            if(indexPath.row==_result.count){
            [_display insertObject:model.answer atIndex:indexPath.row];
            selectedRow=indexPath.row-1;
        }else{
            
         [_display insertObject:model.answer atIndex:indexPath.row+1];
           selectedRow=indexPath.row; 
        }
        }else{
            
            flag=YES;
        }
    }
    
    [self.tableView reloadData];
}

@end
