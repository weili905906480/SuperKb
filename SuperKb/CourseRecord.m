//
//  CourseRecord.m
//  SuperKb
//
//  Created by weili on 14-9-22.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "CourseRecord.h"
@implementation CourseRecord
@synthesize tableName,year,professional,term;

-(NSString*) getStringFromRecord
{
    NSString *result=[self.year stringByAppendingFormat:@"-%@-%@",self.professional,self.tableName];
    return result;
}
+(CourseRecord*) getRecordFromString:(NSString*) str
{
    NSArray *results=[str componentsSeparatedByString:@"-"];
    CourseRecord *record=[[CourseRecord alloc]init];
    record.year=[results objectAtIndex:0];
    record.professional=[results objectAtIndex:1];
    record.tableName=[results objectAtIndex:2];
    return record;
}
@end
