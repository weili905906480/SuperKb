//
//  NoteModel.h
//  SuperKb
//
//  Created by weili on 14-9-30.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NoteModel : NSObject
@property(strong,nonatomic) NSData *imageDate;
@property(strong,nonatomic) NSString *title;
@property(strong,nonatomic) NSString *yearAndmonth;
@property(strong,nonatomic) NSString *time;
@property(strong,nonatomic) NSString *detailMessage;
@end
