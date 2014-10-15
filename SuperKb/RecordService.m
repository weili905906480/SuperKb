//
//  RecordService.m
//  SuperKb
//
//  Created by weili on 14-9-22.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "RecordService.h"
@interface RecordService () {
@private
    
}
@property(nonatomic,strong) NSString *fileName;
@end
static RecordService *shanre;
@implementation RecordService
@synthesize records=_records;
//文件的名称
@synthesize fileName=_fileName;

-(id) init
{
    self=[super init];
    if(self)
    {
        //获取应用程序沙盒的Documents目录  
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);  
        NSString *plistPath1 = [paths objectAtIndex:0];  
        //NSFileManager *manager=[[NSFileManager alloc]init];
        //得到完整的文件名  
        //if(![manager fileExistsAtPath:_fileName])
        _fileName=[plistPath1 stringByAppendingPathComponent:@"courses.plist"];         
        
        NSLog(@"_filename=%@",_fileName);
    }
    return self;
}
+(RecordService*) shareInstance
{
   
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        shanre=[[RecordService alloc]init];
    });
    return shanre;
}



-(void) insertRecord:(CourseRecord*) record
{
    NSMutableDictionary *dic=[[NSMutableDictionary alloc]initWithContentsOfFile:self.fileName];
    if(dic==nil)
    {
        dic=[[NSMutableDictionary alloc]init];
    }
    NSMutableDictionary *model=[[NSMutableDictionary alloc]initWithCapacity:4];
    [model setObject:record.year forKey:@"year"];
    [model setObject:record.professional forKey:@"class"];
    [model setObject:record.term forKey:@"term"];
    [dic setObject:model forKey:record.tableName];
    if([dic writeToFile:_fileName atomically:YES])
    {
        NSLog(@"写入成功");
    }
    
    //存储表名到NSuserDefault中
    [self storeLastTable:record.tableName];
}
//查看记录是否存在
-(CourseRecord*) recordHasExist:(CourseRecord *)record
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:_fileName];
    NSLog(@"dic=%@",dic);    
    for(NSDictionary *model in dic.allValues)
    {
        if([record.year isEqualToString:[model objectForKey:@"year"]]&&[record.professional isEqualToString:[model objectForKey:@"class"]]&&[record.term isEqualToString:[model objectForKey:@"year"]])
        {
            return record;
        }
    }
    return nil;
}
//得到表名
-(NSString*) getTableName
{
    
    NSArray *allkeys=[self.records keysSortedByValueUsingSelector:@selector(compare:)];
    CourseRecord *record=[CourseRecord getRecordFromString:[self.records objectForKey:[allkeys lastObject]]];
    if(record){
    return record.tableName;
    }
    return nil;
}
-(NSString*) getlastTable
{
  
    NSString *tableName=[[NSUserDefaults standardUserDefaults]  objectForKey:@"lastTable"];
    return tableName;
    
}
-(void) storeLastTable:(NSString *)lastTable
{
    [[NSUserDefaults standardUserDefaults] setObject:lastTable forKey:@"lastTable"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

-(NSInteger) getTables
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:_fileName];
  
    return dic.allKeys.count;
}
-(NSMutableArray*) allTables
{
    NSMutableDictionary *dic=[NSMutableDictionary dictionaryWithContentsOfFile:_fileName];
    NSArray *arr=dic.allValues;
    NSMutableArray *result=[NSMutableArray arrayWithArray:arr];
    return result;
}
@end
