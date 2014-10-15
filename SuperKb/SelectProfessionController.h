//
//  SelectProfessionController.h
//  SuperKb
//
//  Created by weili on 14-9-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ThirdPostRequest.h"
#import "RecordService.h"
@interface SelectProfessionController : UIViewController<UITableViewDataSource,UITableViewDelegate,SendCourse,UIAlertViewDelegate>
@property(nonatomic,strong) NSDictionary *professions;
@property(nonatomic,strong) NSString *profession;
@end
