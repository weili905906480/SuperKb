//
//  ChatService.m
//  SuperKb
//
//  Created by weili on 14-9-26.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "ChatService.h"
#import "FMDBTool.h"
@interface ChatService()
{
    //使用文件来进行数据的存储
    NSString *fileName;
    
    
    NSString *serviceFile;
}
-(BOOL) open;
@end
@implementation ChatService
-(id)init
{
    self=[super init];
    if (self) {
        //fileName=[[NSBundle mainBundle]pathForResource:@"chatRecord" ofType:@"plist"];
        
        //获取应用程序沙盒的Documents目录  
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES);  
        NSString *plistPath1 = [paths objectAtIndex:0];  
        
        //得到完整的文件名  
        fileName=[plistPath1 stringByAppendingPathComponent:@"chatRecord.plist"];
        serviceFile=[plistPath1 stringByAppendingPathComponent:@"service.plist"]; 
        NSLog(@"fileName=%@",fileName);
    }
    return self;
     
}
-(void) insertChatModel:(NSMutableArray*) models isRoobet:(BOOL) roobet
{
    //将其转化成可以plist中的数据
    NSMutableArray *res=[[NSMutableArray alloc]init];
    
    for (ChatModel *model in models) {
        NSNumber *num=[NSNumber numberWithBool:model.isFromCustom];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:num,@"isFromCustom",model.message,@"message",model.date,@"date", nil];
        [res addObject:dic];
    }
    NSDictionary *file=[NSDictionary dictionaryWithObject:res forKey:@"Root"];
    
    NSLog(@"file=%@",file);
    if(roobet){
    if([file  writeToFile:fileName atomically:YES])
    {
        NSLog(@"写入成功");
    }
    }else{
        if([file writeToFile:serviceFile atomically:YES])
        {
            NSLog(@"写入文件service成功");
        }
    }
}
-(NSMutableArray*) findAllModel:(BOOL) roobet
{
    NSDictionary *res;
    if(roobet)
    {
        res=[NSDictionary dictionaryWithContentsOfFile:fileName];
    }else{
        res=[NSDictionary dictionaryWithContentsOfFile:serviceFile];
    }
    
    NSMutableArray *models=[[NSMutableArray alloc]init];
    NSArray *arr=[res objectForKey:@"Root"];
    for(NSDictionary *dic in arr)
    {
        ChatModel *model=[[ChatModel alloc]init];
        model.isFromCustom=[[dic objectForKey:@"isFromCustom"] intValue];
        
        model.message=[dic objectForKey:@"message"];
        model.date=[dic objectForKey:@"date"];
        [models addObject:model];
    }
    return models;
}

-(BOOL) open
{
    return [[FMDBTool instanceTool] openDB:@"myDB.sqlite"];
}
@end
