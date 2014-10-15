//
//  CouModel.h
//  SuperKb
//
//  Created by weili on 14-9-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CouModel : NSObject
@property(nonatomic,assign) int hasClass;
@property(nonatomic,strong) NSString *nameAndTea;
@property(nonatomic,strong) NSString *weekendAndClass;
@property(nonatomic,assign) int *other;
@end
