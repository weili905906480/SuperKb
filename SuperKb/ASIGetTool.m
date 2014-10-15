//
//  ASIGetTool.m
//  WeatherDemo
//
//  Created by weili on 14-9-1.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "ASIGetTool.h"
#import "ASIHTTPRequest.h"
#import "ASIFormDataRequest.h"
@implementation ASIGetTool
@synthesize completeBlock;
-(NSData*) startSyn:(NSString*) url
{
    NSData *data=nil;
    
    NSURL *URL=[[NSURL alloc]initWithString:url];
    ASIHTTPRequest *request=[[ASIHTTPRequest alloc]initWithURL:URL];
    [request setRequestMethod:@"GET"];
    [request setTimeOutSeconds:60];//设置超时时间
    //开始发送同步的请求
    [request startSynchronous];
    
    if(request.error)
    {
        NSLog(@"发送get请求出错");
        return data;
    }
    if(request.responseStatusCode==200)
    {
    data=request.responseData;
    }
    return data;
}

//发送异步的get请求
-(void) startAsyn:(NSString*) url
{
    
    NSURL *URL=[NSURL URLWithString:url];
    ASIHTTPRequest *getRequest=[[ASIHTTPRequest alloc]initWithURL:URL];
    [getRequest setRequestMethod:@"GET"];
    [getRequest setTimeOutSeconds:60];
    //getRequest.delegate=self;
    //使用block完成数据请求
    [getRequest setCompletionBlock:^() {
        self.completeBlock(getRequest.responseData);
    }];
    [getRequest startAsynchronous];
    
}


-(NSData*) startPostSyn:(NSString *)url andData:(NSData *)send andKey:(NSString*) key
{
    NSData *data=nil;
    NSURL *URL=[NSURL URLWithString:url];
    
    //这种方式相当于使用表格的方式来发送数据
    ASIFormDataRequest *request=[[ASIFormDataRequest alloc]initWithURL:URL];
    [request setRequestMethod:@"POST"];
    [request addData:send forKey:key];
    [request setTimeOutSeconds:60];
    
    [request startSynchronous];
    if(request.error)
    {
        NSLog(@"发送同步的post请求出错");
        return  data;
    }
    
    data=request.responseData;
    
    return data;
    
    
}

-(void) startPostAsyn:(NSString *)url andData:(NSData *)send andKey:(NSString *)key
{
   //开始进行post请求
    NSURL *URL=[NSURL URLWithString:url];
    
     ASIFormDataRequest *request=[ASIFormDataRequest requestWithURL:URL];
    [request setRequestMethod:@"POST"];
    [request setData:send forKey:key];
    [request setTimeOutSeconds:60];
    request.delegate=self;
    
    
    //使用block完成数据请求
    [request setCompletionBlock:^() {
         self.completeBlock(request.responseData);
    }];
    //[request startASynchronous];
    [request startAsynchronous];
}

#pragma -请求完成的代理方法
-(void) requestFinished:(ASIHTTPRequest *)request
{
    //发送通知
    
    NSString *res=[[NSString alloc]initWithData:request.responseData encoding:NSUTF8StringEncoding];
    NSLog(@"res=%@",res);
    [[NSNotificationCenter defaultCenter] postNotificationName:@"chat" object:res userInfo:nil];
}


-(void) requestFailed:(ASIHTTPRequest *)request
{
    NSLog(@"发送请求出错");
}
//添加一个下载的方法
-(void) downLoad:(NSString*) url andProgress:(UIProgressView*) progress
{
    downRequest=[ASIFormDataRequest requestWithURL:[NSURL URLWithString:url]];
     
    //下载首先需要得到一个下载的文件名
    NSString *fileName=[url lastPathComponent];
                                 
    //然后构造一个下载的路径
    NSString *downPath=[NSHomeDirectory() stringByAppendingFormat:@"/Documents/%@",fileName];
    NSLog(@"downLoad=%@",downPath);
    
    [downRequest setDownloadProgressDelegate:progress];
    //采用kvo来监听这个下载进度
    [progress addObserver:self forKeyPath:@"progress" options:NSKeyValueObservingOptionNew context:nil];
    [downRequest setDownloadDestinationPath:downPath];
    [downRequest startAsynchronous];
    //这里还可以设置一个进度条
    
}
-(void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    NSLog(@"value%@",[change objectForKey:@"new"]);
}

/*设置缓存策略
-(void)  setCase{
    //创建缓存对象
    ASIDownloadCache *caseDown=[[ASIDownloadCache alloc]init];
    
    //设置缓存目录         
    NSString *document=[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"];
    NSLog(@"文件目录是:%@",document);
    [caseDown setStoragePath:document];//设置缓存存储的目录
    //设置缓存策略
    [caseDown setDefaultCachePolicy:ASIOnlyLoadIfNotCachedCachePolicy];//这种策略表示如果本地有缓存就用本地的，否则就到网络上去取    
    //request.cacheStoragePolicy=ASICacheForSessionDurationCacheStoragePolicy;
    //[caseDown retain];
    request.cacheStoragePolicy=ASICachePermanentlyCacheStoragePolicy;//这种策略是持久化的缓存,会存储在permanentStore这个文件中,这种缓存会导致客户端直接去本地在
    [request setDownloadCache:caseDown];//这里由于caseDown是assgin，所以在arc中无法设置成功    
}*/
@end
