//
//  CourseDBService.h
//  SuperKb
//
//  Created by weili on 14-9-21.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseModelToDB.h"
@interface CourseDBService : NSObject

-(id) initWithTable:(NSString*) tableName;
-(BOOL) insertCourse:(CourseModelToDB*) course andTableName:(NSString*) name;
//查找所有数据的方法
-(NSMutableArray*) findAllCourse:(NSString*) table;
//修改课程
-(BOOL) modifyCourse:(CourseModelToDB*) model fromCourse:(CourseModelToDB*) oldModel tableName:(NSString*) name;

//删除课程
-(BOOL) deleteCourse:(CourseModelToDB*) model andTableName:(NSString*) name;
@end
