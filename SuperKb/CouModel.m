//
//  CouModel.m
//  SuperKb
//
//  Created by weili on 14-9-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "CouModel.h"

@implementation CouModel
@synthesize nameAndTea,weekendAndClass;
@synthesize hasClass;
@synthesize other;
-(NSString*) description
{
    return  [NSString stringWithFormat:@"flag=%d,name=%@,week=%@,other=%d",hasClass,nameAndTea,weekendAndClass,other];
}
@end
