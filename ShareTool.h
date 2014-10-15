//
//  ShareTool.h
//  SuperKb
//
//  Created by weili on 14-9-18.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CourseRecord.h"
@class ShareTool;
@interface ShareTool : NSObject
//使用单例来得到
@property(nonatomic,strong) NSArray *attributions;
@property(nonatomic,strong) NSMutableDictionary *changeArrri;
@property(nonatomic,strong) NSMutableArray *courseName; 
@property(nonatomic,strong) NSData *data;
//这个属性用来记录存储的表的信息
@property(nonatomic,strong) CourseRecord *tableRecord;
+(ShareTool*) shareInstance;
-(NSArray*) attributions;
-(NSDictionary*) changeArrri; 
@end
