//
//  SecondPostRequest.m
//  SuperKb
//
//  Created by weili on 14-9-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//



#import "SecondPostRequest.h"
#import "FirstGetRequest.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "ShareTool.h"
@interface SecondPostRequest() {
}
-(NSMutableDictionary*) parser:(NSMutableData*) data;
@end

@implementation SecondPostRequest
@synthesize att;
@synthesize proDelegate=_proDelegate;
@synthesize data=_data;
@synthesize block;
//使用webservice来进行请求数据
-(void) getProfessional:(NSMutableDictionary *)attri
{
    NSURL *url=[NSURL URLWithString:BASEURL];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    NSString *dataBo=[NSString stringWithFormat:GetProfessionalURL,[attri objectForKey:@"view"],[attri objectForKey:@"event"],[attri objectForKey:@"year"],[attri objectForKey:@"term"],[attri objectForKey:@"depart"]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60];
    [request setHTTPBody:[dataBo dataUsingEncoding:NSUTF8StringEncoding]];

    NSURLConnection *connect=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(_data==nil)
    {
        _data=[NSMutableData data];
    }
}


#pragma NSConntectDelegate methods
-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"网络请求出错");
}
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    //[self parser:_data];
    //使用代理来传送数据
    [self.proDelegate sendPro:[self parser:_data]];
    
    ShareTool *tool=[ShareTool shareInstance];
    tool.data=_data;
    //self.block();
}

-(NSMutableDictionary*) parser:(NSMutableData *)data
{
    //解析数据
    //TFHpple *helper=[[TFHpple alloc]initWithHTMLData:data];
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);    
    NSString *utfEncode =[[NSString alloc]initWithData:data encoding:enc];
    
    TFHpple *helper=[[TFHpple alloc]initWithHTMLData:[utfEncode dataUsingEncoding:NSUTF8StringEncoding]];
    NSMutableDictionary *results=[[NSMutableDictionary alloc]init];
    NSArray *selects=[helper searchWithXPathQuery:@"//select"];
    
    for (TFHppleElement *select in selects)
    {
        NSDictionary *attris=[select attributes];
        //找到对应的select 
        if ([[attris objectForKey:@"name"] isEqualToString:@"selClass"])
        {
            NSArray *children=select.children;
            //NSLog(@"children=%@",children);
            for(TFHppleElement *child in children)
            {
                if([child.tagName isEqualToString:@"option"])
                {
                    NSString *content=[[[child children] lastObject] content];
                    NSString *value=[[child attributes] objectForKey:@"value"];
                    [results setObject:content forKey:value];
                }
            }
            
        }
        
    }
    return results;
}
@end
