//
//  DayController.h
//  SuperKb
//
//  Created by weili on 14-9-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
/*
 这个类用于滚动翻页的课程表查询
 */

@protocol GotoDetailedCourse <NSObject>

-(void) gotoDetailed:(UIViewController*) contro;
@end
@interface DayController : UIViewController<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>
@property(nonatomic,strong) NSArray *allCourse;
@property(nonatomic,assign) id<GotoDetailedCourse> delegate;
@end
