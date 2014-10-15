//
//  QuestionModel.h
//  SuperKb
//
//  Created by weili on 14-10-8.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface QuestionModel : NSObject
@property(nonatomic,assign) BOOL flag;
@property(nonatomic,strong) NSString *question;
@property(nonatomic,strong) NSString *answer;
@end
