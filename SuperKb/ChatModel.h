//
//  ChatModel.h
//  SuperKb
//
//  Created by weili on 14-9-26.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ChatModel : NSObject
@property(nonatomic,strong) NSString *message;
@property(nonatomic,assign) BOOL isFromCustom;
@property(nonatomic,strong) NSString *date;
@end
