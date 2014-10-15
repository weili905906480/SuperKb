//
//  QuestionCell.h
//  SuperKb
//
//  Created by weili on 14-10-8.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface QuestionCell : UITableViewCell

-(id) initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier;
@property(nonatomic,assign) BOOL flag;
@property(nonatomic,strong) UIImageView *view;
-(void) textContent:(NSString*) str;
@end
