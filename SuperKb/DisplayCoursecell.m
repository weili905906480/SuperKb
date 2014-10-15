//
//  DisplayCoursecell.m
//  SuperKb
//
//  Created by weili on 14-9-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "DisplayCoursecell.h"

@implementation DisplayCoursecell
@synthesize label=_label;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    UIButton *button=nil;
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        _label=[[ARLabel alloc]initWithFrame:CGRectMake(0, 7, 20, 25)];
        _label.numberOfLines=0;
        _label.textColor=[UIColor blackColor];
        [self.contentView addSubview:_label];
        for(int i=0;i<7;i++)
        {
            button=[[UIButton alloc]initWithFrame:CGRectMake(20+43*i, 0, 40, 43)];
            [button setBackgroundColor:[UIColor colorWithRed:0.0118 green:0.4824 blue:0.9412 alpha:1]];
            [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
            button.titleLabel.font=[UIFont systemFontOfSize:8]; 
            button.titleLabel.lineBreakMode=0;
            button.tag=111+i;
            [self.contentView addSubview:button];
        }
    }
    return self;  
}
@end
