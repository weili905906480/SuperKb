//
//  NoteCell.m
//  SuperKb
//
//  Created by weili on 14-9-30.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "NoteCell.h"
 
@implementation NoteCell
@synthesize label=_label;
@synthesize label2=_label2;
@synthesize customImageView=_customImageView;

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
       
        _label=[[UILabel alloc]initWithFrame:CGRectMake(10, 5, 200, 20)];
        [self.contentView addSubview:_label];
        _label2=[[UILabel alloc]initWithFrame:CGRectMake(10, 30, 200, 20)];
        _label2.font=[UIFont systemFontOfSize:13];
        _label2.numberOfLines=0;
        _label2.lineBreakMode=0;
        [self.contentView addSubview:_label2];
    }
    return self;
}

-(UIImageView*) customImageView
{
    if(_customImageView==nil)
    {
        _customImageView=[[UIImageView alloc]initWithFrame:CGRectMake(218, 2, 100, self.bounds.size.height-2)];
        [self.contentView addSubview:_customImageView];
    }
    return _customImageView;
}
-(void) layoutSubviews
{
    [super layoutSubviews];
    UIImageView *myImage=[[UIImageView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height-1, 320, 1)];
    myImage.image=[UIImage imageNamed:@"line"];
    [self.contentView addSubview:myImage];
}
-(void) noteContent:(NSString *)text
{
    CGSize constraint=CGSizeMake(200, 1000);
    CGSize size=[text sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    if(size.width>190)
    {
        _label2.frame=CGRectMake(10, 30, 200, 50);
    }
    _label2.text=text;
}
@end
