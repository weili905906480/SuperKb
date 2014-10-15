//
//  DetailedCourseController.h
//  SuperKb
//
//  Created by weili on 14-9-22.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 这个类用来展示详细的课程信息
 */

#import "CourseModelToDB.h"
@interface DetailedCourseController : UIViewController<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong) NSString *courseName;
@property(nonatomic,strong) CourseModelToDB *res;
@property(nonatomic,strong) UITableView *tableView;
@end
