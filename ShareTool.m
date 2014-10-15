//
//  ShareTool.m
//  SuperKb
//
//  Created by weili on 14-9-18.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "ShareTool.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "CourseModelToDB.h"
#import "NSString+URLEncode.h"
static ShareTool *instance;
@interface ShareTool() {
@private
    
}
-(NSArray*) parserAttribute:(NSData *)data;
@end
@implementation ShareTool
@synthesize attributions;
@synthesize data=_data;
@synthesize changeArrri=_changeArrri;
@synthesize courseName=_courseName;
@synthesize tableRecord=_tableRecord;
+(ShareTool*)shareInstance
{
    static dispatch_once_t once;
       dispatch_once(&once, ^{
        instance=[[self alloc]init];
    });
    return instance;
}
//这个用来解析得到参数
-(NSArray*) parserAttribute:(NSData *)data
{
    if(data==nil)//网络出错，那么返回为空
    {
        return nil;
    }
    NSMutableArray *array=[[NSMutableArray alloc]initWithCapacity:2];
    TFHpple *helper=[[TFHpple alloc]initWithHTMLData:data];
    //开始解析数据
    NSArray *inputs=[helper searchWithXPathQuery:@"//input"];
    
    for(TFHppleElement *input in inputs)
    {
        NSDictionary *att=[input attributes];
        
        if([[att objectForKey:@"name"] isEqualToString:@"__VIEWSTATE"]||[[att objectForKey:@"name"] isEqualToString:@"__EVENTVALIDATION"])
        {
            NSString *res=[att objectForKey:@"value"];
            [array addObject:[res URLEncode]];//进行url转码
        }
    }
        return array;
}
-(NSArray*) attributions
{
    return [self parserAttribute:_data];
}
-(NSDictionary*) changeArrri
{
    if(_changeArrri==nil)
    {
        _changeArrri=[NSMutableDictionary dictionary];
    }
    [_changeArrri setValue:[self.attributions objectAtIndex:0]  forKey:@"view"];
    [_changeArrri setValue:[self.attributions objectAtIndex:1] forKey:@"event"];
    return _changeArrri;
}

-(CourseRecord*) tableRecord
{
    if(_tableRecord==nil)
    {
        _tableRecord=[[CourseRecord alloc]init];
    }
    return _tableRecord;
}
//将课程信息存储到数组中
-(void) setCourseName:(NSMutableArray *)courseName
{
    NSMutableArray *array=[[NSMutableArray alloc]init];
    
    [array addObject:@"其他课程"];
    for (CourseModelToDB *model in courseName) {
        if(![array containsObject:model.courseName])
        [array addObject:model.courseName];
    }
    _courseName=array;
}
@end
