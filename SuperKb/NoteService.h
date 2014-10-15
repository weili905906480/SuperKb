//
//  NoteService.h
//  SuperKb
//
//  Created by weili on 14-10-6.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NoteModel.h"
/**
 这个类用来存储笔记记录,使用单例模式
 */
@interface NoteService : NSObject
+(NoteService*) shareIntance;
//得到所有的数据
-(NSMutableArray*) allNotes;
//保存所有的数据
-(NSMutableArray*) storeNotes:(NoteModel*) notes;

//修改数据
-(NSMutableArray*) modifyNote:(NoteModel*) note andIndex:(NSIndexPath*) index;
-(BOOL) StoreToFile;
@end
