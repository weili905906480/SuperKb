//
//  HelpViewController.h
//  SuperKb
//
//  Created by weili on 14-10-8.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChatController.h"
/*
 这个类用来创建一个客服的功能
 */
@interface HelpViewController : UIViewController<SendMessage>
{
    UILabel *label2;
    UILabel *label3;
}
-(void) createView;
@end
