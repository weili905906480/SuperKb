//
//  KBTabBarController.m
//  SuperKb
//
//  Created by weili on 14-9-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "KBTabBarController.h"

@implementation KBTabBarController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
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
    
    //伪造一个数据
    NSUserDefaults *defaults=[NSUserDefaults standardUserDefaults];
    NSMutableArray *user=[NSMutableArray  arrayWithObjects:@"大四 上学期",@"第1周(本周)",@"40",@"image",@"6",@"周一",@"无", nil];
    [defaults setValue:user forKey:@"userMessage"];    
    
    //创建三个子视图
    self.tabBar.tintColor=[UIColor whiteColor];
    FirstTabController *first=[[FirstTabController alloc]init];
    SecondTabController *second=[[SecondTabController alloc]init];
    ThridTabController *thrid=[[ThridTabController alloc]init];
    
    //self.tabBar.selectedImageTintColor=[UIColor colorWithRed:0.0431 green: 0.6588 blue:1.0000 alpha:1];
    self.tabBar.selectionIndicatorImage=[UIImage imageNamed:@"ic_tabbar_bg_click.9"];
    //self.tabBarItem
    UINavigationController *navi1=[[UINavigationController alloc]initWithRootViewController:first];
    navi1.navigationBar.tintColor=[UIColor whiteColor];
    UINavigationController *navi2=[[UINavigationController alloc]initWithRootViewController:second];

    UINavigationController *navi3=[[UINavigationController alloc]initWithRootViewController:thrid];
    NSArray *allNavi=[NSArray arrayWithObjects:navi1,navi2,navi3, nil];
    self.viewControllers=allNavi; 
    
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
