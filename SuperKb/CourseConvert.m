//
//  CourseConvert.m
//  SuperKb
//
//  Created by weili on 14-9-21.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "CourseConvert.h"
#import "CouModel.h"
#import "CourseModelToDB.h"
#import "CourseDBService.h"
@interface CourseConvert () {
@private
    CourseDBService *service;
    NSString *tableName;
}
//将从网络请求的model转化成存储到数据库中的model


-(CourseModelToDB*) convert:(CouModel*) couModel andDay:(int) day andJie:(int) jie;
-(void) convertFromDic:(NSDictionary*) dic;
-(void) convertModelToDB:(NSArray*) arr andJie:(int) jie;
//这个用于特殊情况的转换
-(NSMutableArray*) otherConvert:(NSArray*) arr;
@end

@implementation CourseConvert


-(id) initWithTableName:(NSString *)name
{
    self=[super init];
    if(self)
    {
        //使用数据库存储数据
        service=[[CourseDBService  alloc]initWithTable:name];
        tableName=name;
    }
    return self;
}
-(void) convertFromDic:(NSDictionary *)dic
{
    for (NSString *key in dic.allKeys) {
        if([key isEqualToString:@"第2节"])
        {
        [self convertModelToDB:[dic objectForKey:key]   andJie:1]; 
        }else if([key isEqualToString:@"第3节"])
        {
          [self convertModelToDB:[dic objectForKey:key]   andJie:2];            
        }else if([key isEqualToString:@"第4节"])
        {
           [self convertModelToDB:[dic objectForKey:key]   andJie:3]; 
        }else if([key isEqualToString:@"第5节"])
        {
           [self convertModelToDB:[dic objectForKey:key]   andJie:4]; 
        }else if([key isEqualToString:@"第6节"])
        {
        [self convertModelToDB:[dic objectForKey:key]   andJie:5];
        }else if([key isEqualToString:@"第7节"])
        {
         [self convertModelToDB:[dic objectForKey:key]   andJie:6];   
        }    
    }
}

-(void) convertModelToDB:(NSArray *)arr andJie:(int) jie
{
    
    //NSMutableArray *everyCourse=[self otherConvert:arr];
    NSLog(@"-----------arr=%@",arr);
    NSLog(@"数组的大小=%d",arr.count);
   // NSMutableArray *everyCourse=[NSMutableArray arrayWithArray:arr];
    
    for(int i=0;i<arr.count;i++)
    {
        CouModel *model=[arr objectAtIndex:i];
        CourseModelToDB *dbModel=[self  convert:model andDay:i+1 andJie:jie];
        [service insertCourse:dbModel andTableName:tableName];
    }
}

-(CourseModelToDB*) convert:(CouModel *)couModel andDay:(int) day andJie:(int) jie
{
    CourseModelToDB *model=Nil;
    if(couModel.hasClass==0){
    model=[[CourseModelToDB alloc]init];
      if([couModel.nameAndTea hasPrefix:@" "])
      {
          NSArray *result=[couModel.nameAndTea componentsSeparatedByString:@" "];
          model.courseName=[result objectAtIndex:1];
          model.teacher=[result objectAtIndex:2];
      }else{
        
    model.courseName=[[couModel.nameAndTea componentsSeparatedByString:@" "] objectAtIndex:0];
    model.teacher=[[couModel.nameAndTea componentsSeparatedByString:@" "] objectAtIndex:1];
      }   
    NSArray *classesAndroom=[couModel.weekendAndClass componentsSeparatedByString:@"\n"];
    model.classes=[classesAndroom objectAtIndex:0];
    NSArray *classRoomAndweek=[[classesAndroom objectAtIndex:1] componentsSeparatedByString:@" "];
    model.classroom=[classRoomAndweek objectAtIndex:0];
    model.weekendLast=[classRoomAndweek objectAtIndex:1];
    
    }/*else if(couModel.hasClass==2){
        NSArray *names=[couModel.nameAndTea componentsSeparatedByString:@" "];
        model.courseName=[[names objectAtIndex:0] stringByAppendingFormat:@"or%@",[names objectAtIndex:2]];
        model.teacher=[[names objectAtIndex:1] stringByAppendingFormat:@"或%@",[names objectAtIndex:3]];
        NSArray *class=[couModel.weekendAndClass componentsSeparatedByString:@"-"];
        NSString *class1=[class objectAtIndex:0] ;
        NSString *class2=[class objectAtIndex:1];
        NSString *class3=[[class1 componentsSeparatedByString:@"\n"] objectAtIndex:0] ;
        NSString *class4=[[class2 componentsSeparatedByString:@"\n"] objectAtIndex:0];
        model.classes=[class3 stringByAppendingFormat:@"or%@",class4];
        NSString *classRoom1=[[[[class1 componentsSeparatedByString:@"\n"]objectAtIndex:1] componentsSeparatedByString:@" "]objectAtIndex:0];
         NSString *classRoom2=[[[[class2 componentsSeparatedByString:@"\n"]objectAtIndex:1] componentsSeparatedByString:@" "]objectAtIndex:0];        
        model.classroom=[classRoom1 stringByAppendingFormat:@"or%@",classRoom2];
        NSString *week1=[[[[class1 componentsSeparatedByString:@"\n"]objectAtIndex:1] componentsSeparatedByString:@" "]objectAtIndex:1];
        NSString *week2=[[[[class2 componentsSeparatedByString:@"\n"]objectAtIndex:1] componentsSeparatedByString:@" "]objectAtIndex:1];
        model.weekendLast=[week1 stringByAppendingFormat:@"or%@",week2];
    }*/
    model.day=day;
    model.jie=jie;
    return model;
}

-(NSMutableArray*) otherConvert:(NSArray *)arr
{
    NSMutableArray *result=[NSMutableArray array];
    int j=-1;
    BOOL flag=YES;
    CouModel *model=nil;
    for (int i=0;i<arr.count;i++)
    {
        model=[arr objectAtIndex:i];
        if(model.hasClass==2&&flag)
        {
            //CouModel *m=(CouModel*)[arr objectAtIndex:i+2];            //NSString *twoName=[model.nameAndTea stringByAppendingFormat:m.nameAndTea];
            //model.nameAndTea=model.nameAndTea;
            //NSString *twoClasses=[model.weekendAndClass stringByAppendingFormat:@"-",m.weekendAndClass];
            //model.weekendAndClass=model.weekendAndClass;
            model.hasClass=0;
            j=i+2;
            flag=NO;
        }
        if(i!=j||i!=j-1)
        {
            [result addObject:model];
        }
        
    }
    return result ;
}
@end
