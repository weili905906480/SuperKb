//
//  NoteMesController.h
//  MyNotes
//
//  Created by weili on 14-9-14.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TSEmojiView.h"
#import "NoteModel.h"

typedef enum {
    built,
    modify
} BUILDorMODIFY;
@protocol InsertNoteRecord <NSObject>

-(void) addNote:(NoteModel*) model isModify:(BOOL) flag;

@end

@class KGNotePad;
@interface NoteMesController : UIViewController<UITextViewDelegate,TSEmojiViewDelegate>
{
    int lineNum;
    KGNotePad *textView;
    NSString *lastText;
    BOOL flag;
    float current;
}
@property(assign,nonatomic) id<InsertNoteRecord> noteDelegate;
@property(strong,nonatomic) NSString *noteType;
@property(strong,nonatomic) NoteModel *edit;
@end
