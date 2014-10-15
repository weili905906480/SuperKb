//
//  HelpViewController.m
//  SuperKb
//
//  Created by weili on 14-10-8.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "HelpViewController.h"
#import "QuestionController.h"
#import "ChatController.h"
@interface HelpViewController()
{
    
}
@end
@implementation HelpViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"小纸条";
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self createView];    
    NSDictionary *dic=[[NSUserDefaults standardUserDefaults] objectForKey:@"service"];
    if(dic){
    label2.text=[dic objectForKey:@"time"];
    label3.text=[dic objectForKey:@"message"];
    }
}

-(void) createView
{
    UIScrollView *scroll=[[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, 320, 416)];
    scroll.contentSize=CGSizeMake(320, 480);
    [self.view addSubview:scroll];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeCustom];   
    button.frame=CGRectMake(0, 20, 321, 60);
    //button.backgroundColor=[UIColor redColor];
    UIImageView *view1=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 1)];
    view1.image=[UIImage imageNamed:@"line"];
    [button addSubview:view1];
    UIImageView *view2=[[UIImageView alloc]initWithFrame:CGRectMake(0, 59, 320, 1)];
    view2.image=[UIImage imageNamed:@"line"]; 
    [button addSubview:view2];
    
    UIImageView *view=[[UIImageView alloc]initWithFrame:CGRectMake(10, 5, 50, 50)];
    view.image=[UIImage imageNamed:@"ic_service_avatar.jpg"];
    [button addSubview:view];
    
    UILabel *label1=[[UILabel alloc]initWithFrame:CGRectMake(70, 5, 80, 30)];
    label1.text=@"客服";
    [button addSubview:label1];
    
    [button addTarget:self action:@selector(gotoService:) forControlEvents:UIControlEventTouchUpInside];
    label2=[[UILabel alloc]initWithFrame:CGRectMake(230, 5, 90, 15)];
    label2.font=[UIFont systemFontOfSize:12];
    label3=[[UILabel alloc]initWithFrame:CGRectMake(70, 40, 100, 18)];
    label3.font=[UIFont systemFontOfSize:14];
    [button addSubview:label3];
    [button addSubview:label2];
    [scroll addSubview:button];
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
-(void) gotoService:(UIButton*) button
{
    ChatController *controller=[[ChatController alloc]init];
    controller.isRoobet=NO;
    controller.delegate=self;
    [self.navigationController pushViewController:controller animated:YES];
}
-(void) senMessage:(ChatModel *)model
{
    label3.text=model.message;
    label2.text=model.date;
    NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:model.message,@"message",model.date,@"time", nil];
    [[NSUserDefaults standardUserDefaults] setValue:dic forKey:@"service"];
    [[NSUserDefaults standardUserDefaults]synchronize];
    
}
@end
