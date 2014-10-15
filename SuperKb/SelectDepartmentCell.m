//
//  SelectDepartmentCell.m
//  SuperKb
//
//  Created by weili on 14-9-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "SelectDepartmentCell.h"
#import "ARLabel.h"
@implementation SelectDepartmentCell
@synthesize label=_label;
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _label=[[ARLabel alloc]initWithFrame:CGRectMake(0, 5, 50, 35)];
        [self.contentView addSubview:_label];     
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.frame=CGRectMake(80, 5, 200, 35);
    
}
@end
