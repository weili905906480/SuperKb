//
//  ChatCell.m
//  SuperKb
//
//  Created by weili on 14-9-26.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "ChatCell.h"

@interface ChatCell () {
@private
    
}
@property(nonatomic,strong) UIImageView *image;
@property(nonatomic,strong) UIImageView *imageText;
@end

@implementation ChatCell
@synthesize isFromCustom=_isFromCustom;
@synthesize currentTime=_currentTime;
@synthesize button=_button;
@synthesize image=_image;
@synthesize imageText=_imageText;
-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier 
{
    self=[super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if(self)
    {
           _image=[[UIImageView alloc]init];
            _button=[[UIButton alloc]init];
        _imageText=[[UIImageView alloc]init];
        _button.titleLabel.font=[UIFont systemFontOfSize:13];
        _button.tintColor=[UIColor whiteColor];
        _button.titleLabel.lineBreakMode=0;
        [_button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [_imageText addSubview:_button];
        
        _currentTime=[[ARLabel alloc]initWithFrame:CGRectMake(125, 0, 70, 15)];
        _currentTime.backgroundColor=[UIColor  colorWithRed:0.8588 green:0.8863 blue:0.9294 alpha:1];
        _currentTime.text=@"晚上 19:30:49";
        [self.contentView addSubview:_currentTime];
        [self.contentView addSubview:_imageText];
        [self.contentView addSubview:_image];
        self.selectionStyle=UITableViewCellSelectionStyleNone;
    }
    return self;
}
-(void) layoutSubviews
{
    [super layoutSubviews];
    self.contentView.backgroundColor=[UIColor colorWithRed:0.8588 green:0.8863 blue:0.9294 alpha:1];
    if(_isFromCustom)
    {
        _image.frame=CGRectMake(250, self.bounds.size.height-70, 60, 60);
    }else
    {
        _image.frame= CGRectMake(10, self.bounds.size.height-70, 60, 60);  
    }
    
}
-(void) changeButtonAndImage:(BOOL) isFromCustom andIsRoobet:(BOOL)roobet
{
    if(isFromCustom)
    {
        _image.image=[UIImage imageNamed:@"face_test"];
        //_imageText.frame=CGRectMake(140, 10, 100, 40);
        //[_button setBackgroundImage:[UIImage imageNamed:@"bubbleSelf"] forState:UIControlStateNormal];
        _imageText.image=[[UIImage imageNamed:@"bubbleSelf"] stretchableImageWithLeftCapWidth:20 topCapHeight:14]; 
    }else{
        
        if(!roobet)
        {
            _image.image=[UIImage imageNamed:@"ic_service_avatar.jpg"];  
        }else{
        _image.image=[UIImage imageNamed:@"default_head_online"];
        }
        //_imageText.frame=CGRectMake(90, 10, 100, 40);
        //[_button setBackgroundImage:[UIImage imageNamed:@"bubble"] forState:UIControlStateNormal];
        //[_button setImage:[UIImage imageNamed:@"bubble"] forState:UIControlStateNormal];
       _imageText.image=[[UIImage imageNamed:@"bubble"] stretchableImageWithLeftCapWidth:20 topCapHeight:14];
         
    }
    //_button.frame=CGRectMake(5, 5, _imageText.frame.size.width-10, _imageText.frame.size.height-10);
    _isFromCustom=isFromCustom;
    
}

-(void) setButtonTitle:(NSString *)message isFromCustom:(BOOL)fromCustom
{
    CGSize constraint=CGSizeMake(180, 1000);
    
    
    CGSize size=[message sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:constraint lineBreakMode:UILineBreakModeClip];
    //根据字体的大小去决定button的width和高度
    
    if(fromCustom)
    {
        _imageText.frame=CGRectMake(230-size.width, 15, size.width+20, 26);
        _button.frame=CGRectMake(10, 5, size.width, 16);
        
    }else{
        _imageText.frame=CGRectMake(70, 15, size.width+20, 26);
        _button.frame=CGRectMake(10, 5, size.width, 16);
    }
    //这里开始换行
    if(size.height>30)
    {
        if(fromCustom){
        _button.frame=CGRectMake(_button.frame.origin.x, _button.frame.origin.y, 180, size.height); 
        _imageText.frame=CGRectMake(_imageText.frame.origin.x-100, _imageText.frame.origin.y, 200, size.height+10);
        }else
        {
            _button.frame=CGRectMake(_button.frame.origin.x, _button.frame.origin.y, 180, size.height); 
            _imageText.frame=CGRectMake(_imageText.frame.origin.x, _imageText.frame.origin.y, 200, size.height+10);            
        }
        //NSLog(@"imageText=%@",NSStringFromCGRect(_imageText.frame));
    }
    [_button setTitle:message forState:UIControlStateNormal];
    //float height=[_button.titleLabel
}
@end
