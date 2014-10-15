//
//  ChatCell.h
//  SuperKb
//
//  Created by weili on 14-9-26.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
@interface ChatCell : UITableViewCell
@property(nonatomic,assign) BOOL isFromCustom;
@property(nonatomic,strong) ARLabel *currentTime; 
@property(nonatomic,strong) UIButton *button;
-(void) changeButtonAndImage:(BOOL) isFromCustom andIsRoobet:(BOOL) roobet;

-(void) setButtonTitle:(NSString*) message isFromCustom:(BOOL) fromCustom;
@end
