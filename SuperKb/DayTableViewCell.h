//
//  DayTableViewCell.h
//  SuperKb
//
//  Created by weili on 14-9-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ARLabel.h"
/*
 这个类用于创建一个自定义的cell样式
 */
@interface DayTableViewCell : UITableViewCell
@property(nonatomic,strong) ARLabel *jie;
@property(nonatomic,strong) ARLabel *courseName;
@property(nonatomic,strong) ARLabel *classRoom;
@property(nonatomic,strong) ARLabel *week;
@property(nonatomic,strong) ARLabel *time;
@end
