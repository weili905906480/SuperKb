//
//  ChatController.h
//  SuperKb
//
//  Created by weili on 14-9-26.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASIGetTool.h"
#import "TSEmojiView.h"
#import "ChatService.h"
#import "ChatModel.h"
@protocol SendMessage <NSObject>

-(void) senMessage:(ChatModel*) model;

@end

@interface ChatController : UIViewController<UITextFieldDelegate,UITableViewDataSource,UITableViewDelegate,TSEmojiViewDelegate>
{
    UIView *view;
    float viewHeight;
    UITextField *field;
    ASIGetTool *tool;
    BOOL flag;
    ChatService *service;
    CGFloat cellHeight;
}
@property(nonatomic,assign) id<SendMessage> delegate;
@property(nonatomic,strong) NSMutableArray *messages;
@property(nonatomic,assign) BOOL isRoobet;
-(NSString*) getCurrentTime;

-(void) customReloadView;
@end
