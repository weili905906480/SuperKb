//
//  FirstGetRequest.h
//  SuperKb
//
//  Created by weili on 14-9-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

/**
 这个类用来进行第一次get请求
 */


@protocol passDepartment <NSObject>

-(void) passDepart:(NSDictionary*) dic;

@end
#define BASEURL @"http://jwc.yangtzeu.edu.cn:8080/kb.aspx"
#import <Foundation/Foundation.h>
@interface FirstGetRequest : NSObject
@property(nonatomic,strong) NSMutableData *htmlData;
@property(nonatomic,strong) id<passDepartment> departmentDegelate;
-(id) initGetRequest;
-(NSDictionary*) parserDepartment;

@end
