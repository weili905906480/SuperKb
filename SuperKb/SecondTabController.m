//
//  SecondTabController.m
//  SuperKb
//
//  Created by weili on 14-9-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "SecondTabController.h"
#import "ARLabel.h"
#import "ChatController.h"
#import "NoteRootController.h"
#import "HelpViewController.h"
@implementation SecondTabController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title=@"发现";
        
        [self.tabBarItem setFinishedSelectedImage:[UIImage imageNamed:@"ic_tabbar_fou_pressed"] withFinishedUnselectedImage:[UIImage imageNamed:@"ic_tabbar_fou_normal"]];
        [self.tabBarItem setTitle:@"发现"];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor
            blackColor],UITextAttributeTextColor,[UIFont systemFontOfSize:12],UITextAttributeFont, nil];
        NSDictionary *select=[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:0.0431 green:0.6588 blue:1.0000 alpha:1], UITextAttributeTextColor,nil];
        
        self.title=@"发现";
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
    
    //kIOS7;
    
    NSArray *threeButton=[NSArray arrayWithObjects:@"小纸条",@"考试倒计时",@"超级实习生", nil];
    NSArray *four=[NSArray arrayWithObjects:@"大学男神",@"小应用", nil];
    self.view.backgroundColor=[UIColor orangeColor];
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    //button.highlighted=NO;
    UIImageView *image1=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_item4"]];
    image1.frame=CGRectMake(10, 15, 40, 40);
    [button addSubview:image1];
    
    ARLabel *label=[[ARLabel alloc]initWithFrame:CGRectMake(60, 10, 100, 20)];
    [button setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
    //设置背景颜色不改变
    button.adjustsImageWhenHighlighted=NO;
    label.text=@"下课聊";
    [button addSubview:label];
    
    ARLabel *label1=[[ARLabel alloc]initWithFrame:CGRectMake(60, 40, 200, 15)];
    label1.text=@"下课后一起吐槽，分享小秘密";
    [button addSubview:label1];
    button.frame=CGRectMake(5, 5, 310, 70);
    
    
    UIButton *button1=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button1.frame=CGRectMake(5, 80, 310, 70);
    
    
    UIImageView *image2=[[UIImageView alloc]initWithImage:[UIImage imageNamed:@"bg_item8"]];
    image2.frame=CGRectMake(10, 15, 40, 40);
    [button1 addSubview:image2];
    
    ARLabel *label3=[[ARLabel alloc]initWithFrame:CGRectMake(60, 10, 100, 20)];
    [button1 setBackgroundImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal]; 
    button1.adjustsImageWhenHighlighted=NO;    label3.text=@"烂笔头";
    [button1 addSubview:label3];
    
    ARLabel *label4=[[ARLabel alloc]initWithFrame:CGRectMake(60, 35, 200, 30)];
    label4.numberOfLines=0;
    button1.tag=140;
    [button1 addTarget:self action:@selector(gotoChat:) forControlEvents:UIControlEventTouchUpInside];
    label4.text=@"好记性不如烂笔头，记下\n你的笔记，作业，事物";
    [button1 addSubview:label4];    
    for(int i=0;i<3;i++)
    {
      UIButton *button2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button2.adjustsImageWhenHighlighted=NO; 
        [button2 setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
        NSString *imageName=[NSString stringWithFormat:@"bg_item%d",i+1];
        image.image=[UIImage imageNamed:imageName];
        [button2 addSubview:image];
        button2.tag=152+i;
        
        [button2 addTarget:self action:@selector(gotoChat:) forControlEvents:UIControlEventTouchUpInside];
        ARLabel *label4=[[ARLabel alloc]initWithFrame:CGRectMake(20, 75, 60, 20)];
        label4.textColor=[UIColor blackColor];
        label4.text=[threeButton objectAtIndex:i];
        [button2 addSubview:label4];
        button2.frame=CGRectMake(5+i*105, 155, 100, 100);
        [self.view addSubview:button2];
    }
    
    for (int i=0; i<2; i++) {
        UIButton *button3=[UIButton buttonWithType:UIButtonTypeRoundedRect];
        button3.frame=CGRectMake(5+i*105, 260, 100, 100);
          [button3 setBackgroundImage:[UIImage imageNamed:@"back2"] forState:UIControlStateNormal];
        UIImageView *image=[[UIImageView alloc]initWithFrame:CGRectMake(20, 10, 60, 60)];
        NSString *imageName=[NSString stringWithFormat:@"bg_item%d",i+3];
        image.image=[UIImage imageNamed:imageName];
        [button3 addSubview:image];        
        
        ARLabel *label4=[[ARLabel alloc]initWithFrame:CGRectMake(20, 75, 60, 20)];
        label4.textColor=[UIColor blackColor];
        label4.text=[four objectAtIndex:i];
        [button3 addSubview:label4];        
        button3.adjustsImageWhenHighlighted=NO;
        
        [button3 addTarget:self action:@selector(gotoChat:) forControlEvents:UIControlEventTouchUpInside];
        button3.tag=150+i;
        [self.view addSubview:button3];
    }

    [self.view addSubview:button1];
    [self.view addSubview:button];
    
}

-(void) gotoChat:(UIButton*) button
{
    if(button.tag==151)
    {
        ChatController *cont=[[ChatController alloc]init];
        cont.isRoobet=YES;
        [self.navigationController pushViewController:cont animated:YES];
    }else if(button.tag==140)
    {
        NoteRootController *control=[[NoteRootController alloc]init];
        
        [self.navigationController pushViewController:control animated:YES];
    }else if(button.tag==152)
    {
        HelpViewController *control=[[HelpViewController alloc]init];
        [self.navigationController pushViewController:control animated:YES];
    }
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

@end
