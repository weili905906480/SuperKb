//
//  CourseConvert.h
//  SuperKb
//
//  Created by weili on 14-9-21.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
/**
 这个类负责将网络请求到的数据转换成CourseModelToDB的一个数组，然后存入到数据库中
 */
@interface CourseConvert : NSObject
-(id) initWithTableName:(NSString*) name; 
-(void) convertFromDic:(NSDictionary*) dic;
@end
