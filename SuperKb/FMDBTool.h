//
//  FMDBTool.h
//  SBJsonAndFMDB练习
//
//  Created by weili on 14-9-5.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
@interface FMDBTool : NSObject
{
    FMDatabase *db;
}
//使用单例来创建一个实例
+(FMDBTool*) instanceTool;
-(BOOL) openDB:(NSString*) dbName;

-(BOOL) exceptQuery:(NSString *) sql andParmas:(NSArray*) array;
-(NSMutableArray*) query:(NSString*) sql andParmas:(NSArray*) array; 
@end
