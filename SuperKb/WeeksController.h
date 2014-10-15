//
//  WeeksController.h
//  SuperKb
//
//  Created by weili on 14-9-22.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChangeWeek <NSObject>

-(void) changeWeek:(NSString*) week;

@end

@interface WeeksController : UITableViewController
@property(nonatomic,strong) NSMutableArray *weekends;
@property(nonatomic,assign) id<ChangeWeek> delegateWeek;
@end
