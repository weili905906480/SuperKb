//
//  ASIGetTool.h
//  WeatherDemo
//
//  Created by weili on 14-9-1.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//


/*
 *这个类封装了同步，异步的请求和下载的请求
 *1.其中同步的请求直接通过返回值得到
 *2.异步的请求通过设置block来获得
 *3.下载是通过一个url参数和一个进度条参数来调用
 */
#import <Foundation/Foundation.h>
#import "ASIHTTPRequestDelegate.h"
#import "ASIFormDataRequest.h"
//定义一个block来传递参数
typedef void(^passData)(NSData*);
@interface ASIGetTool : NSObject<ASIHTTPRequestDelegate>
{
    ASIFormDataRequest *downRequest;
    
}

@property(nonatomic,copy) passData completeBlock;
//@property(nonatomic,assign) BOOL showProgress;
-(NSData*) startSyn:(NSString*) url;//开始同步的get请求
-(void) startAsyn:(NSString*) url;//开始异步的get请求

-(NSData*) startPostSyn:(NSString *)url andData:(NSData*) send andKey:(NSString*) key;//开始同步的post请求

-(void) startPostAsyn:(NSString *)url andData:(NSData*) send andKey:(NSString*) key;//开始异步的post请求

//添加一个下载的方法
-(void) downLoad:(NSString*) url andProgress:(UIProgressView*) progress;

-(void) setCase;
@end
