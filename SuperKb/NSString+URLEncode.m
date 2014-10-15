//
//  NSString+URLEncode.m
//  WeatherDemo
//
//  Created by weili on 14-9-16.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "NSString+URLEncode.h"
#import "NSString+URLEncode.h"
@implementation NSString (URLEncode)

-(NSString*) URLEncode
{
    NSString *outputStr =  (__bridge  NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  
        (__bridge CFStringRef)self,  
            NULL,  
            (CFStringRef)@"!*'();:@&=+$,/?%#[]",  
        kCFStringEncodingUTF8);  
    return outputStr; 
}
-(NSString*) URLDeencode
{
    NSMutableString *outputStr = [NSMutableString stringWithString:self];  
    [outputStr replaceOccurrencesOfString:@"+"  
                               withString:@" "  
                                  options:NSLiteralSearch  
                                    range:NSMakeRange(0, [outputStr length])];  
    
    return [outputStr stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];  
}

-(NSString*) URLEncodeGBK
{
    NSString *outputStr =  (__bridge  NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,  
                (__bridge CFStringRef)self,  
                                    NULL,  
    (CFStringRef)@"!*'();:@&=+$,/?%#[]",  
        kCFStringEncodingGB_18030_2000);  
    return outputStr; 
}
@end
