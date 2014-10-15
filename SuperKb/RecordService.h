//
//  RecordService.h
//  SuperKb
//
//  Created by weili on 14-9-22.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseRecord.h"
/*
 这里使用plist文件来进行数据存储添加多张课表
 
 使用NSUserDefault来将最后的用户选着的课表进行一个保存
 */

@interface RecordService : NSObject
@property(nonatomic,strong) NSMutableDictionary *records;

+(RecordService*) shareInstance;

-(void) insertRecord:(CourseRecord*) record;

-(CourseRecord*) recordHasExist:(CourseRecord*) record;
-(void) storeLastTable:(NSString *)lastTable;
-(NSString*) getlastTable;
-(NSMutableArray*)  allTables;

//得到表名
//-(NSString*) getTableName;

//得到已经存在的表多少
-(NSInteger) getTables;
//得到上一次的表名
-(NSString*) getLastTableName;
@end
