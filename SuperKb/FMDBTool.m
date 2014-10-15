//
//  FMDBTool.m
//  SBJsonAndFMDB练习
//
//  Created by weili on 14-9-5.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//
/*
 *fmdb的使用：fmdb是一个封装的sqlite的框架
 
 
 */


#import "FMDBTool.h"
#import "FMDB.h"


@implementation FMDBTool

static FMDBTool *instance;
//使用单例来创建一个
+(FMDBTool*) instanceTool
{
    static dispatch_once_t once;
    dispatch_once(&once, ^{
        instance=[[self alloc]init];
        //db=[[FMDatabase alloc]init];
    });
    return instance;
}
-(BOOL) openDB:(NSString*)dbName
{
    NSString *bath=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *dbPath=[bath stringByAppendingPathComponent:dbName];
    NSLog(@"dbPath=%@",dbPath);
    if(db==nil)
    {
        db=[[FMDatabase alloc]initWithPath:dbPath];
    }
    return [db open];
}

//执行增，删，改和建表操作
-(BOOL) exceptQuery:(NSString *) sql andParmas:(NSArray*) array;
{
    BOOL result=[db executeUpdate:sql withArgumentsInArray:array];
    //关闭数据库连接
    [db close];
    return result; 
}

//这个数组中存放的是NSDictionary对象，其中键值是列名，需要区分大小写
-(NSMutableArray*)  query:(NSString *)sql andParmas:(NSArray *)array
{
    FMResultSet *result=[db executeQuery:sql withArgumentsInArray:array];
    
    if([result columnCount]==0)
    {
        NSLog(@"没有查询到结果");
        return nil;
    }
    NSMutableArray *arr=[NSMutableArray array];
    while ([result next]) {
        NSDictionary *dic=[result resultDictionary];
        [arr addObject:dic];
    }
    //关闭数据库连接
    [db close];
    return arr;
}


@end
