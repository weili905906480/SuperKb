//
//  NoteCell.h
//  SuperKb
//
//  Created by weili on 14-9-30.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NoteCell : UITableViewCell
@property(nonatomic,strong) UILabel *label;
@property(nonatomic,strong) UILabel *label2;
@property(nonatomic,strong) UIImageView *customImageView;

-(void) noteContent:(NSString*) text;
@end
