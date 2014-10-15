//
//  NoteRootController.h
//  SuperKb
//
//  Created by weili on 14-9-30.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NoteMesController.h"
@interface NoteRootController : UIViewController<UITableViewDataSource,UITableViewDelegate,InsertNoteRecord>

@property(nonatomic,strong) NSMutableArray *notes;
-(NSMutableArray*) getNewNotes:(NSMutableArray*) note;
@end
