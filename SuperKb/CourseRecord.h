//
//  CourseRecord.h
//  SuperKb
//
//  Created by weili on 14-9-22.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

/*
 这个类是记录课程表数目的model
 */
@interface CourseRecord : NSObject
@property(nonatomic,strong) NSString *year;
@property(nonatomic,strong) NSString *professional;
@property(nonatomic,strong) NSString *tableName;
@property(nonatomic,strong) NSString *term;

//类似于归档和解归档
-(NSString*) getStringFromRecord;

+(CourseRecord*) getRecordFromString:(NSString*) str;
@end
