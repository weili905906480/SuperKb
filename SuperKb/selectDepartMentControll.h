//
//  selectDepartMentControll.h
//  SuperKb
//
//  Created by weili on 14-9-19.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FirstGetRequest.h"
#import "SecondPostRequest.h"
@interface selectDepartMentControll : UIViewController<UITableViewDataSource,UITableViewDelegate,passDepartment,UIPickerViewDataSource,UIPickerViewDelegate,sendProfessionalMessage>
@property(nonatomic,strong) NSDictionary *results;
@property(nonatomic,strong) UITableView *tableView;

@end
