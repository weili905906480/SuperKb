//
//  ChatService.h
//  SuperKb
//
//  Created by weili on 14-9-26.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ChatModel.h"
/*
 这个类负责存储聊天数据
 */
@interface ChatService : NSObject

-(void) insertChatModel:(NSMutableArray*) models isRoobet:(BOOL) roobet;
-(NSMutableArray*) findAllModel:(BOOL) roobet;
@end
