//
//  ThirdPostRequest.m
//  SuperKb
//
//  Created by weili on 14-9-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "ThirdPostRequest.h"
#import "FirstGetRequest.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "CouModel.h"
@implementation ThirdPostRequest
@synthesize data=_data;
@synthesize mesDelegate;
//使用这个类请求网络得到数据
-(void) getCourse:(NSDictionary *)attri
{
    NSURL *url=[NSURL URLWithString:BASEURL];
    NSMutableURLRequest *request=[NSMutableURLRequest requestWithURL:url];
    
   // NSString *data=@"__EVENTTARGET=btQuery&__EVENTARGUMENT=&__LASTFOCUS=&__VIEWSTATE=%@&__EVENTVALIDATION=%@&selYear=2014&selTerm=1&selKblb=1&selDepart=%@&selClass=%@";  
    NSString *dataBo=[NSString stringWithFormat:GetCourseURL,[attri objectForKey:@"view"],[attri objectForKey:@"event"],[attri objectForKey:@"year"],[attri objectForKey:@"term"],[attri objectForKey:@"depart"],[attri objectForKey:@"class"]];
    [request setHTTPMethod:@"POST"];
    [request setTimeoutInterval:60];
    [request setHTTPBody:[dataBo dataUsingEncoding:NSUTF8StringEncoding]];
    
    NSURLConnection *connect=[[NSURLConnection alloc]initWithRequest:request delegate:self];
    if(_data==nil)
    {
        _data=[NSMutableData data];
    }
}

#pragma NSConnection delegate
-(void) connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [_data appendData:data];
}
-(void) connectionDidFinishLoading:(NSURLConnection *)connection
{
    [self.mesDelegate sendMess:[self parser:_data]];
}

-(void) connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"error");
}
//解析
-(NSMutableDictionary*) parser:(NSMutableData *)data
{
    NSStringEncoding enc = CFStringConvertEncodingToNSStringEncoding(kCFStringEncodingGB_18030_2000);
    NSString *res =[[NSString alloc]initWithData:data encoding:enc];
    TFHpple *htmlHelper=[[TFHpple alloc]initWithHTMLData:[res dataUsingEncoding:NSUTF8StringEncoding]];
    NSArray *tdElements=[htmlHelper searchWithXPathQuery:@"//td"];
    NSMutableDictionary *dictionary=[[NSMutableDictionary alloc]init];
      NSMutableArray *courses=nil;
    //NSLog(@"td=%@",tdElements);
    BOOL isTwo=NO;
    BOOL isFour=NO;
    for (TFHppleElement *tds in tdElements ) {
        NSArray *tdchild =tds.children;
        
        CouModel *model=nil;
       
        NSLog(@"tds=%@",tds.tagName);
        if([tds.tagName isEqualToString:@"td"])
        {
            /*if(results!=nil)
             {
             [results appendString:@"br"];
             }*/
            if(flag)
            {
                model=[[CouModel alloc]init];
                
            }
            
        } 
        for(TFHppleElement *childS in tdchild){
            for(TFHppleElement *child in childS.children){
                         
                if([child.tagName isEqualToString:@"text"])
                {
                    NSLog(@"tagName=%@",[child content]);
                    //创建一个字典
                    record=child.content;
                    if([record isEqualToString:@"第1节"]||[record isEqualToString:@"第2节"]||[record isEqualToString:@"第3节"]||[record isEqualToString:@"第4节"]||[record isEqualToString:@"第5节"]||[record isEqualToString:@"第6节"])
                    {
                        
                        if([record isEqualToString:@"第6节"])
                            isFour=YES;
                        
                        //如果course存在，那么把它加到字典中
                        if(courses!=nil)
                        {
                            [dictionary setObject:courses forKey:record];
                        }
                        flag=YES;
                        model=nil;
                        courses=[[NSMutableArray alloc]init];
                    }else if([child.content isEqualToString:@" "]){
                        model=[[CouModel alloc]init];
                        model.hasClass=1;
                        NSLog(@"这是一个点");
                    }else
                    {
                        if(model!=nil)
                        {
                            if(!isTwo)
                            {
                                model.nameAndTea=record;
                                isTwo=YES;
                            }else{
                                model.weekendAndClass=record;
                                isTwo=NO;
                            }
                        }
                    }
                }
            }
        }
        
        if(model!=nil&&courses!=nil)
        {
            [courses addObject:model];
        }        
    }
        
    
    if(isFour)
    {
        [dictionary setObject:courses forKey:@"第7节"];
        isFour=NO;
    }  
    
    return [self getLastResult:dictionary];
}
//包含数字返回YES

/*-(BOOL) hasANumber:(NSString *)str
{
    BOOL has=NO;
    for(int i=0;i<str.length;i++)
    {
        //NSLog(@"i=%@",[res substringWithRange:NSMakeRange(i, 1 )]); 
        if([[str substringWithRange:NSMakeRange(i, 1)] intValue])
        {
            has=YES;
        }
    }
    return has;
}*/

-(NSMutableDictionary*) getLastResult:(NSMutableDictionary*) dic
{
    NSMutableDictionary *dictionary=[NSMutableDictionary dictionary];    

    NSMutableArray *array=nil;
    for(NSString *week in dic.allKeys)
    {
        array=(NSMutableArray*)[dic objectForKey:week];
        [dictionary setObject:array forKey:week];
    }
    return dictionary;
}

/*
-(NSMutableArray*) removeArray:(NSMutableArray*) array
{
    //int a=0;
    for(int i=0;i<array.count-1;i++)
    {
        CouModel *model=[array objectAtIndex:i];
        CouModel *model1=[array objectAtIndex:i+1];
        if(model.hasClass==model1.hasClass&&[model.nameAndTea isEqualToString:model1.nameAndTea]&&[model.weekendAndClass isEqualToString:model1.weekendAndClass]){
            model.hasClass=2;
            model1.hasClass=2;
        }
    }
    return array;
}*/
@end
