//
//  DayTableViewCell.m
//  SuperKb
//
//  Created by weili on 14-9-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "DayTableViewCell.h"

@implementation DayTableViewCell
@synthesize jie=_jie;
@synthesize week=_week;
@synthesize courseName=_courseName;
@synthesize classRoom=_classRoom;
@synthesize time=_time;
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _jie=[[ARLabel alloc]initWithFrame:CGRectMake(10, 20, 20, 20)];
        _jie.textAlignment=UITextAlignmentCenter;
        [self.contentView addSubview:_jie];
        
        _courseName=[[ARLabel alloc]initWithFrame:CGRectMake(40, 5, 200, 20)];
        _courseName.textColor=[UIColor greenColor];
        [self.contentView addSubview:_courseName];
        _classRoom=[[ARLabel alloc]initWithFrame:CGRectMake(45, 25, 100, 15)];
        _classRoom.textColor=[UIColor grayColor];
        [self.contentView addSubview:_classRoom];
        _week =[[ARLabel alloc]initWithFrame:CGRectMake(45, 45, 100, 15)];
        _week.textColor=[UIColor grayColor];
        [self.contentView addSubview:_week];

        _time=[[ARLabel alloc]initWithFrame:CGRectMake(270, 5, 45, 20)];
        _time.textColor=[UIColor grayColor];
        [self.contentView addSubview:_time];
        
    }
    return self;
}
@end
