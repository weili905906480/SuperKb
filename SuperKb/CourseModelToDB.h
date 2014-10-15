//
//  CourseModelToDB.h
//  SuperKb
//
//  Created by weili on 14-9-21.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CourseModelToDB : NSObject
@property(nonatomic,assign) int day;
@property(nonatomic,assign) int jie;
@property(nonatomic,strong) NSString *courseName;
@property(nonatomic,strong) NSString *teacher;
@property(nonatomic,strong) NSString *classes;
@property(nonatomic,strong) NSString *classroom;
@property(nonatomic,strong) NSString *weekendLast;
@end
