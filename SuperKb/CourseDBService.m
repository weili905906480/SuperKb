//
//  CourseDBService.m
//  SuperKb
//
//  Created by weili on 14-9-21.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "CourseDBService.h"
#import "FMDBTool.h"
#import "CourseDBService.h"
@interface CourseDBService(){
@private
    
}
//打开数据库
-(BOOL) open;
-(void) createTable:(NSString*) tableName;
@end

/**
 这个类用来进行数据课程表信息的存储
 */
@implementation CourseDBService

-(id) initWithTable:(NSString *)tableName
{
    self=[super init];
    if(self)
    {
        [self createTable:tableName]; 
    }
    return self;
}
-(BOOL) open
{
    return [[FMDBTool instanceTool] openDB:@"myDB.sqlite"];
}

-(void) createTable:(NSString *)tableName 
{
    if([self open])
    {
        //创建表
        NSString *sql=[NSString stringWithFormat:@"create table %@(record INTEGER PRIMARY KEY AUTOINCREMENT NOT NULL,day integer, jie integer,courseName VARCHAR(20),classes varchar(20),teacher varchar(20),weekLast varchar(20),classRoom varchar(20))",tableName];
        if([[FMDBTool instanceTool]  exceptQuery:sql andParmas:nil])
        {
            NSLog(@"创建表成功");
        }
        
    }
}
-(BOOL) insertCourse:(CourseModelToDB *)course  andTableName:(NSString *)name
{
    if(![self open])
    {
        NSLog(@"数据库打开失败");
    }
    NSString *sql=[NSString   stringWithFormat:@"INSERT INTO %@(day,jie,courseName,classes,teacher,weekLast,classRoom) values(?,?,?,?,?,?,?)",name];
    NSNumber *num=[NSNumber numberWithInt:course.day];
    NSNumber *num2=[NSNumber numberWithInt:course.jie];
    NSArray *array=[NSArray arrayWithObjects:num,num2,course.courseName,course.classes,course.teacher,course.weekendLast,course.classroom, nil];
    
    if ([[FMDBTool instanceTool] exceptQuery:sql andParmas:array])
    {
        NSLog(@"插入成功");
        return YES;
    }
    return NO;
}

-(NSMutableArray*) findAllCourse:(NSString*) table
{
    
    NSString *sql=[NSString stringWithFormat:@"select * from %@",table];
    if(![self open])
    {
        NSLog(@"数据库打开失败");
    }
    
    NSMutableArray *results=[[FMDBTool instanceTool] query:sql andParmas:Nil];
    NSMutableArray *res=[NSMutableArray array];
    for (NSDictionary *dic in  results)
    {
        CourseModelToDB *model=[[CourseModelToDB alloc]init];
        model.jie=[[dic objectForKey:@"jie"] intValue];
        model.day=[[dic objectForKey:@"day"] intValue];
        model.courseName=[dic objectForKey:@"courseName"];
        model.classes=[dic objectForKey:@"classes"];
        model.teacher=[dic objectForKey:@"teacher"];
        model.weekendLast=[dic objectForKey:@"weekLast"];
        model.classroom=[dic objectForKey:@"classRoom"];
        [res  addObject:model];
    }
    return res;
}
-(BOOL) modifyCourse:(CourseModelToDB *)model fromCourse:(CourseModelToDB*)oldModel  tableName:(NSString *)name
{
    NSString *sql=[NSString stringWithFormat:@"update %@ set jie=%d,day=%d,courseName='%@',teacher='%@',classes='%@',classroom='%@',weekLast='%@' where jie=%d and day=%d",name,model.jie,model.day,model.courseName,model.teacher,model.classes,model.classroom,model.weekendLast,oldModel.jie,oldModel.day];
    NSLog(@"sql=%@",sql);
    if(![self open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![[FMDBTool instanceTool] exceptQuery:sql andParmas:nil])
    {
        NSLog(@"修改失败");
        return NO;
    }
    return YES;
}
-(BOOL) deleteCourse:(CourseModelToDB *)model andTableName:(NSString*) name
{
    NSString *sql=[NSString  stringWithFormat: @"delete from %@ where jie=%d and day=%d"];
    if(![self open])
    {
        NSLog(@"数据库打开失败");
        return NO;
    }
    if(![[FMDBTool instanceTool] exceptQuery:sql andParmas:nil])
    {
        NSLog(@"删除失败");
        return NO;
    }
    return YES;
    
}
@end
