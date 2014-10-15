//
//  ThirdPostRequest.h
//  SuperKb
//
//  Created by weili on 14-9-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#define GetCourseURL @"__EVENTTARGET=btQuery&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=%@&__EVENTVALIDATION=%@&selYear=%@&selTerm=%@&selKblb=1&selDepart=%@&selClass=%@"


@protocol SendCourse <NSObject>

-(void) sendMess:(NSMutableDictionary*) course;

@end
@interface ThirdPostRequest : NSObject<NSURLConnectionDelegate,NSURLConnectionDataDelegate>
{
    BOOL flag;
    NSString *record;
    NSMutableString *results;
    NSString *copy;//为防止重复
    int getCourse;//设置这个model的类型这个是
}
@property(nonatomic,strong) NSMutableData *data;
@property(nonatomic,weak) id<SendCourse> mesDelegate;
-(void) getCourse:(NSDictionary*) attri;


//解析数据的方法
-(NSMutableDictionary*) parser:(NSMutableData *)data;
//-(BOOL) hasANumber:(NSString*) str;
-(NSMutableDictionary*) getLastResult:(NSMutableDictionary*) dic;
//-(NSMutableArray*) removeArray:(NSMutableArray*) array;

@end
