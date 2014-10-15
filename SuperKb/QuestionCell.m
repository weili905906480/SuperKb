//
//  QuestionCell.m
//  SuperKb
//
//  Created by weili on 14-10-8.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "QuestionCell.h"
@interface QuestionCell()
{
    @private
    CGFloat height;
    CGFloat imageWidth;
    CGFloat imageHeight;
}
    


@end

@implementation QuestionCell
@synthesize flag=_flag;
@synthesize view=_view;
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
        _view=[[UIImageView alloc]init];
       
    }
    return self;
}

-(void) layoutSubviews
{
    [super layoutSubviews];
    self.textLabel.font=[UIFont systemFontOfSize:18];
    self.textLabel.numberOfLines=0;
    self.textLabel.frame=CGRectMake(0, 10, 320, height);
    if(_flag)
    {
        self.backgroundColor=[UIColor grayColor];
        self.contentView.backgroundColor=[UIColor grayColor];
        [_view removeFromSuperview];
    }else{
        self.contentView.backgroundColor=[UIColor whiteColor];
        self.textLabel.backgroundColor=[UIColor whiteColor];
        _view.frame=CGRectMake(imageWidth, imageHeight, 10, 10);
        //_view.backgroundColor=[UIColor redColor];
         [self.contentView addSubview:_view];
    }
    
}
-(void) textContent:(NSString *)str
{
    CGSize size=CGSizeMake(300, 1000);
    CGSize textSize=[str sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:size lineBreakMode:UILineBreakModeWordWrap];
    self.textLabel.text=str;
    NSInteger hang=textSize.height/22-1;
    CGSize size1=CGSizeMake(1000, 1000);
    CGSize textSize1=[str sizeWithFont:[UIFont systemFontOfSize:18] constrainedToSize:size1 lineBreakMode:UILineBreakModeWordWrap];
    if(hang!=0)
    {
       imageWidth=textSize1.width-hang*textSize.width+10;
        imageHeight=hang*22+16;
    }else
    {
        imageWidth=textSize.width+10;
        imageHeight=16;
    }
    height= textSize.height;                 
}
@end
