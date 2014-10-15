//
//  NoteService.m
//  SuperKb
//
//  Created by weili on 14-10-6.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "NoteService.h"

static NoteService *intance;
@interface NoteService() {
@private
    NSString *fileName;
    NSMutableArray *display;
    NSMutableArray *allNotes;
}
@end

@implementation NoteService

//使用文件来保存数据
-(id) init
{
    self=[super init];
    if(self)
    {
        NSArray *paths=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *path=[paths lastObject];
        fileName=[path stringByAppendingPathComponent:@"note.plist"];
        NSLog(@"note=%@",fileName);//文件的位置
    }
    return self;
}

+(NoteService*) shareIntance
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        intance=[[NoteService alloc]init];
    });
    return intance;
}
//得到所以的记录
-(NSMutableArray*) allNotes
{
    NSMutableDictionary  *notes=[NSMutableDictionary dictionaryWithContentsOfFile:fileName];
    
    if(notes==nil)
    {
        notes=[NSMutableDictionary dictionary];
    }
    //NSMutableArray *arr=[[NSMutableArray alloc]init];
    display=[NSMutableArray array];    
    if(notes.allKeys.count==0)
    {
        
        [notes setValue:display forKey:@"root"];
        if([notes writeToFile:fileName atomically:YES])
        return display;
    }
    
    NSArray *result=[notes objectForKey:@"root"];
    for(NSArray *notes in result){
        NSMutableArray *dayNote=[[NSMutableArray alloc]init];
        for(NSDictionary *note in notes)
        {
            NoteModel *model=[[NoteModel alloc]init];
            model.time=[note objectForKey:@"time"];
            model.title=[note objectForKey:@"title"];
            model.detailMessage=[note objectForKey:@"detailMessage"];
            model.yearAndmonth=[note objectForKey:@"yearAndmonth"];
            [dayNote addObject:model];
        }
        [display addObject:dayNote];
    }
    
    return display;
}

-(NSMutableArray*) storeNotes:(NoteModel*) not 
{
    
    NSArray  *lastNotes=[display lastObject];
    NSMutableArray *lastMutable=[NSMutableArray arrayWithArray:lastNotes];
    NoteModel *lastNote=[lastNotes lastObject];
        if([not.yearAndmonth isEqualToString:lastNote.yearAndmonth])
         {
             [lastMutable addObject:not];
             [display replaceObjectAtIndex:display.count-1 withObject:lastMutable];
         }else{
            NSMutableArray *arr=[[NSMutableArray alloc]init]; 
             [arr addObject:not];
           [display addObject:arr];  
         }
        
    

    //NSDictionary *dic=[NSDictionary dictionaryWithObject:display forKey:@"root"];
   // return [dic writeToFile:fileName atomically:YES];
    return display;
}

-(BOOL) StoreToFile
{
    NSMutableArray *arr=[NSMutableArray array];
    for(NSArray *notes in display)
    {
        NSMutableArray *allNot=[NSMutableArray array];
        for(NoteModel *model in notes)
        {
            NSDictionary *diction=[NSDictionary dictionaryWithObjectsAndKeys: model.time,@"time",model.title,@"title",model.detailMessage,@"detailMessage",model.yearAndmonth,@"yearAndmonth", nil];
            [allNot addObject:diction];
        }
        [arr addObject:allNot];
    }
    NSDictionary *dic=[NSDictionary dictionaryWithObject:arr forKey:@"root"];
    return [dic writeToFile:fileName atomically:YES];
}

-(NSMutableArray*) modifyNote:(NoteModel *)note andIndex:(NSIndexPath*)index
{
    NSArray *arr=[display objectAtIndex:index.section];
    NSMutableArray *change=[NSMutableArray arrayWithArray:arr];
    [change replaceObjectAtIndex:index.row withObject:note];
    [display replaceObjectAtIndex:index.section withObject:change];
    return display;
}
@end
