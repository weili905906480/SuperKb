//
//  FirstTabController.h
//  SuperKb
//
//  Created by weili on 14-9-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThirdPostRequest.h"
#import "FirstGetRequest.h"
#import "SecondPostRequest.h"
#import "CouModel.h"
#import "ShareTool.h"
#import "selectDepartMentControll.h"
#import "DisplayCoursecell.h"
#import "CourseDBService.h"
#import "SecondPostRequest.h"
#import "ThirdPostRequest.h"
#import "FirstGetRequest.h"
#import "CourseDBService.h"
#import "WeeksController.h"
#import "DayController.h"
@interface FirstTabController : UIViewController<UITableViewDataSource,UITableViewDelegate,ChangeWeek,GotoDetailedCourse,UIAlertViewDelegate>
{
    NSArray *array;
    SecondPostRequest *post;
    BOOL flag;
     
}
@property(nonatomic,strong)UITableView *tableView;
@property(nonatomic,strong) NSDictionary *datasource;

@end
