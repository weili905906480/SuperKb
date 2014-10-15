//
//  SecondPostRequest.h
//  SuperKb
//
//  Created by weili on 14-9-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//


/**
 这个类用来发送第一次的post请求，用来得到专业的信息
 */
#define GetProfessionalURL @"__EVENTTARGET=selDepart&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=%@&__EVENTVALIDATION=%@&selYear=%@&selTerm=%@&selKblb=1&selDepart=%@&selClass=170333"
#import <Foundation/Foundation.h>
typedef void(^SendAttri)(NSArray*);
//定义一个协议将数据传输到controller
@protocol sendProfessionalMessage <NSObject>
-(void) sendPro:(NSMutableDictionary*) dictionary;
@end

@interface SecondPostRequest : NSObject<NSURLConnectionDataDelegate,NSURLConnectionDelegate>
@property(nonatomic,strong) NSArray *att;
@property(nonatomic,strong) NSMutableData *data;
@property(nonatomic,strong) SendAttri block;
@property(nonatomic,weak) id<sendProfessionalMessage> proDelegate;
-(void) getProfessional:(NSDictionary*) attri;
@end
