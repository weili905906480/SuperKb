//
//  AddCourseController.h
//  SuperKb
//
//  Created by weili on 14-9-23.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CourseModelToDB.h"
//定义一个枚举来确定是编辑还是修改
typedef   enum{
    Eidt,
    Modify
} EditOrModify;

@interface AddCourseController : UIViewController<UITableViewDelegate,UITableViewDataSource,UITextFieldDelegate>
@property(nonatomic,strong) CourseModelToDB *model;
@property(nonatomic,assign) EditOrModify editOrmodify;
@end
