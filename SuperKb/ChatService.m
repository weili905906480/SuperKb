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
}
-(BOOL) open;
@end
@implementation ChatService
-(id)init
{
    self=[super init];
    if (self) {
        fileName=[[NSBundle mainBundle]pathForResource:@"chatRecord" ofType:@"plist"];
         NSLog(@"fileName=%@",fileName);
    }
    return self;
     
}
-(void) insertChatModel:(NSMutableArray*) models
{
    //将其转化成可以plist中的数据
    NSMutableArray *res=[[NSMutableArray alloc]init];
    
    for (ChatModel *model in models) {
        NSNumber *num=[NSNumber numberWithBool:model.isFromCustom];
        NSDictionary *dic=[NSDictionary dictionaryWithObjectsAndKeys:num,@"isFromCustom",model.message,@"message",model.date,@"date", nil];
        [res addObject:dic];
    }
    NSDictionary *file=[NSDictionary dictionaryWithObject:res forKey:@"Root"];
    
    if([file  writeToFile:fileName atomically:YES])
    {
        NSLog(@"写入成功");
    }
}
-(NSMutableArray*) findAllModel
{
    NSDictionary *res=[NSDictionary dictionaryWithContentsOfFile:fileName];
    
    NSMutableArray *models=[[NSMutableArray alloc]init];
    NSArray *arr=[res objectForKey:@"Root"];
    
    for(NSDictionary *dic in arr)
    {
        ChatModel *model=[[ChatModel alloc]init];
        
        model.isFromCustom=[[dic objectForKey:@"isFromCustom"] intValue];
        model.message=[dic objectForKey:@"message"];
        //model.date=[dic objectForKey:@"date"];
        [models addObject:model];
    }
    return models;
}

-(BOOL) open
{
    return [[FMDBTool instanceTool] openDB:@"myDB.sqlite"];
}
@end
