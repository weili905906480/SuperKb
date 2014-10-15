//
//  FirstGetRequest.m
//  SuperKb
//
//  Created by weili on 14-9-17.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "FirstGetRequest.h"
#import "ASIGetTool.h"
#import "TFHpple.h"
#import "TFHppleElement.h"
#import "NSString+URLEncode.h"
#import "ShareTool.h"

@interface FirstGetRequest() {
@private
    
}

-(void) getAttribute;
@end

@implementation FirstGetRequest
@synthesize htmlData=_htmlData;
@synthesize departmentDegelate;

-(id) initGetRequest{
    self=[super init];
    if(self)
    {
        [self getAttribute];
    }
    return self;
    
}

//使用asi来进行一个同步的网络请求
-(void) getAttribute
{
    ASIGetTool *tool=[[ASIGetTool alloc]init];
      //发送一个异步的请求
    [tool startAsyn:BASEURL];
    [tool setCompleteBlock:^(NSData* data){
        _htmlData=[NSMutableData dataWithData: data];
        ShareTool *tool=[ShareTool shareInstance];
        tool.data=_htmlData;
        [self.departmentDegelate passDepart:[self parserDepartment]];
    }];
}


//这个方法用来解析院系信息
-(NSDictionary*) parserDepartment
{
    
    if(_htmlData==nil)
    {
        return nil;
    }
    //这里解析的是院系的信息
    //NSString *selDepart=nil;
    NSString *filepath=[[NSBundle mainBundle]pathForResource:@"index" ofType:@"html"];
    NSData *data1=[NSData dataWithContentsOfFile:filepath];
    TFHpple *helper=[[TFHpple alloc]initWithHTMLData:data1];
    NSMutableDictionary *results=[[NSMutableDictionary alloc]init];
    NSArray *selects=[helper searchWithXPathQuery:@"//select"];
    
    for (TFHppleElement *select in selects)
    {
        NSDictionary *attris=[select attributes];
        //找到对应的select 
        if ([[attris objectForKey:@"name"] isEqualToString:@"selDepart"])
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
