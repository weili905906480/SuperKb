//
//  ThridCell.m
//  SuperKb
//
//  Created by weili on 14-9-30.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "ThridCell.h"

@implementation ThridCell

@synthesize image=_image;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        self.contentView.backgroundColor=[UIColor whiteColor];
        self.backgroundColor=[UIColor whiteColor];
        _image=[[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 320, 10)];
       [self.contentView addSubview:_image];
        self.accessoryView.backgroundColor=[UIColor whiteColor];
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.backgroundColor=[UIColor whiteColor];
    self.detailTextLabel.backgroundColor=[UIColor whiteColor];
    self.accessoryView.backgroundColor=[UIColor whiteColor];
}
@end
