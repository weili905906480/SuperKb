//
//  ModifyCurrentWeek.h
//  SuperKb
//
//  Created by weili on 14-9-29.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyCurrentWeek : UITableViewController
@property(nonatomic,strong) NSString *currentWeek; 
-(void)createView;

-(void) changeCurrentWeek;
@end
