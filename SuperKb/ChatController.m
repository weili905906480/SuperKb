//
//  ChatController.m
//  SuperKb
//
//  Created by weili on 14-9-26.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "ChatController.h"
#import "ChatCell.h"
#import "ChatModel.h"
#import "NSString+URLEncode.h"
#import "TSEmojiView.h"
#import "QuestionController.h"
@interface ChatController()
{
    @private
    ChatModel *sendModel;
    
    CGFloat everyCell;
}
@property(nonatomic,strong)  UITableView *tableView;
@end
@implementation ChatController 
@synthesize isRoobet=_isRoobet;
@synthesize messages=_messages;
@synthesize tableView=_tableView;
@synthesize delegate=_delegate;
-(id) initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self=[super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {
        self.hidesBottomBarWhenPushed=YES;
    }
    return self;
    
}
- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    view=[[UIView alloc]initWithFrame:CGRectMake(0, 440-64, 320, 40)];
    view.backgroundColor=[UIColor grayColor];
    viewHeight=440-64;
    field=[[UITextField alloc]initWithFrame:CGRectMake(10, 5, 200, 30)];
    //注册键盘通知
    tool=[[ASIGetTool alloc]init];
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardApp:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardHide:) name:UIKeyboardDidHideNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(getMessage:) name:@"chat" object:nil];
    //这里使用键盘的辅助视图来完成textfield的滚动
   
    _tableView=[[UITableView alloc]initWithFrame:CGRectMake(0, 0, 320, 376) style:UITableViewStylePlain];
    _tableView.delegate=self;
    _tableView.dataSource=self;
    _tableView.backgroundColor=[UIColor colorWithRed:0.8588 green:0.8863 blue:0.9294 alpha:1];
    [self.view addSubview:_tableView];
    field.delegate=self;
    field.borderStyle=UITextBorderStyleRoundedRect;
    [view addSubview:field];
    
    UIButton *button=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button.frame=CGRectMake(220, 5, 50, 30);
    [button addTarget:self action:@selector(sendMessage:) forControlEvents:UIControlEventTouchUpInside];
    
    [button setTitle:@"发送" forState:UIControlStateNormal];
    UIButton *button2=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    button2.frame=CGRectMake(275, 5, 40, 30);
    
    [button2 setTitle:@"键盘" forState:UIControlStateSelected];
    [button2 setTitle:@"表情" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(changeKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    
    [view addSubview:button2];
    [view addSubview:button];
    [self.view addSubview:view];
    
    //_messages=[[NSMutableArray alloc]init];
    self.tableView.separatorStyle=UITableViewCellSeparatorStyleNone;
    service=[[ChatService alloc]init];
    _messages=[service findAllModel:_isRoobet];
    if(_messages.count==0)
    {
        //[service 
        ChatModel *model=[[ChatModel alloc]init];
        if(_isRoobet){
        model.message=@"和小黄鸡聊天";
        }else{
            model.message=@"客服";
        }
        model.isFromCustom=NO;
        model.date=[self getCurrentTime];
        [_messages addObject:model];
    }
    
    if(!_isRoobet)
    {
        UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithTitle:@"常见问题" style:UIBarButtonItemStylePlain target:self action:@selector(question:)];
        self.navigationItem.rightBarButtonItem=rightButton;
        UIButton *right=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 40, 40)];
        [right addTarget:self action:@selector(back:) forControlEvents:UIControlEventTouchUpInside];
        [right setBackgroundImage:[UIImage imageNamed:@"ic_navigation_back_normal"] forState:UIControlStateNormal];
        [right setBackgroundImage:[UIImage imageNamed:@"ic_navigation_back_pressed"] forState:UIControlStateSelected];
        UIBarButtonItem *leftButton=[[UIBarButtonItem alloc]initWithCustomView:right];
        self.navigationItem.leftBarButtonItem=leftButton;
    }
    
    int row=[_messages count];
    NSIndexPath *path=[NSIndexPath indexPathForRow:row-1 inSection:0];
    if(row>=0)
    [self.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionBottom];   
    
}



- (void)viewDidUnload
{
    [super viewDidUnload];
}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    //在这里保存数据
    [service insertChatModel:_messages isRoobet:_isRoobet]; 
    
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    return 1;
}

-(CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    //计算text的高度
    CGFloat result=80;
    CGSize constraint=CGSizeMake(180, 1000);
    ChatModel *model=(ChatModel*)[_messages objectAtIndex:indexPath.row];
    NSString *message=model.message;
    
    CGSize size=[message sizeWithFont:[UIFont systemFontOfSize:13] constrainedToSize:constraint lineBreakMode:UILineBreakModeClip];
    if(size.height>50)
    {
        result= size.height+35;
    }
    cellHeight+=result;
    everyCell=result;
    return result;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    
    ChatCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if(cell==nil)
    {
        cell=[[ChatCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    ChatModel *model=[_messages objectAtIndex:indexPath.row];
    //改变
    [cell changeButtonAndImage:model.isFromCustom andIsRoobet:_isRoobet];
    cell.currentTime.text=model.date;
    [cell  setButtonTitle:model.message isFromCustom:model.isFromCustom
     ];
    return cell;
}


#pragma tableView 正在滚动
-(BOOL) textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}


#pragma mark  点击按钮，发送消息
-(void)sendMessage:(UIButton*) button
{
    NSString *mess=field.text;
    if(mess!=nil)
    {
        ChatModel *model=[[ChatModel alloc]init];
        model.message=mess;
        model.isFromCustom=YES;
        model.date=[self getCurrentTime];
        [_messages addObject:model];
        NSString *url=[NSString stringWithFormat:@"http://dev.skjqr.com/api/weixin.php?email=weili905906480@sina.com&appkey=09f40c88820f761f5b62ab554e65a8aa&msg=%@",[mess URLEncodeGBK]];
        [tool startAsyn:url];
        
        [tool setCompleteBlock:^(NSData *data){
            NSString *res=[[NSString alloc]initWithData:data encoding:NSUTF8StringEncoding]; 
            NSArray *results=[res componentsSeparatedByString:@"[msg]"];
            NSString *message=[[[results objectAtIndex:1] componentsSeparatedByString:@"[/msg]"] objectAtIndex:0];
            if(message!=nil)
            {
                ChatModel *model=[[ChatModel alloc]init];
                model.message=[message stringByReplacingOccurrencesOfString:@" " withString:@""];
                model.isFromCustom=NO;
                model.date=[self getCurrentTime];
                [_messages addObject:model];
            }
            int row=[_messages count];
            [self customReloadView];
            
            if(cellHeight>250){
            NSIndexPath *path=[NSIndexPath indexPathForRow:row-1 inSection:0];
            [self.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionBottom];
             self.tableView.frame=CGRectMake(0, -252, 320, 376);   
            [self.tableView deselectRowAtIndexPath:path animated:NO];
            }else if(cellHeight>148&&cellHeight<250){
                NSLog(@"cellheight2=%f",cellHeight);
                CGFloat height=cellHeight-128;
                self.tableView.frame=CGRectMake(0, 0-height, 320, 376);
            }
            
        }];
        
    }

    int row=[_messages count];
    [self customReloadView];
    if(cellHeight>250)
    {
    NSIndexPath *path=[NSIndexPath indexPathForRow:row-1 inSection:0];
    [self.tableView selectRowAtIndexPath:path animated:YES scrollPosition:UITableViewScrollPositionBottom];
        self.tableView.frame=CGRectMake(0, -252, 320, 376);
    }else if(cellHeight>148&&cellHeight<self.tableView.bounds.size.height){
       CGFloat height=cellHeight-128;
        self.tableView.frame=CGRectMake(0, 0-height, 320, 376);
    }
    field.text=@"";
    
}
#pragma mark 键盘出现的通知
-(void) keyboardApp:(NSNotification*) notifition
{
    NSDictionary *dic=[notifition userInfo];
    float animationDuration=[[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];
    CGRect frame=[[dic objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"frame=%@",NSStringFromCGRect(frame));
    //NSLog(@"frame=%@",NSStringFromCGRect(frame));
    [UIView animateWithDuration:animationDuration delay:0 options:UIViewAnimationOptionLayoutSubviews animations:^() {
         view.frame=CGRectMake(0, frame.origin.y-40-64, 320, 40);
        if(cellHeight>=228){
        self.tableView.frame=CGRectMake(0, 0-frame.size.height, 320, 376);
        }
    } completion:^(BOOL finished) {
    }];
}

#pragma 键盘消失的通知
-(void)keyBoardHide:(NSNotification*) notifition
{
    NSDictionary *dic=[notifition userInfo];
    float animationDuration=[[dic objectForKey:UIKeyboardAnimationDurationUserInfoKey] floatValue];   
    [UIView animateWithDuration:animationDuration animations:^() {
        view.frame=CGRectMake(0, 440-64, 320, 40);
        self.tableView.frame=CGRectMake(0, 0, 320, 376);
    }];
}
#pragma 请求网络成功的消息
-(void)  getMessage:(NSNotification*) notifition
{
    NSString *res=(NSString*)notifition.object;
    NSArray *results=[res componentsSeparatedByString:@"[msg]"];
    NSString *message=[[[results objectAtIndex:1] componentsSeparatedByString:@"[/msg]"] objectAtIndex:0];
    if(message!=nil)
    {
        ChatModel *model=[[ChatModel alloc]init];
        model.message=[message stringByReplacingOccurrencesOfString:@" " withString:@""];
        model.isFromCustom=NO;
        model.date=[self getCurrentTime];
        [_messages addObject:model];
    }
    int row=[_messages count];
    [self customReloadView];
    NSIndexPath *path=[NSIndexPath indexPathForRow:row-1 inSection:0];
    [self.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionBottom];
    [self.tableView deselectRowAtIndexPath:path animated:NO];
}
#pragma mark 得到当前的时间
-(NSString*) getCurrentTime
{
    NSDate *date=[NSDate date];
    
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
    
    [formatter setDateFormat:@"hh"];
    int hour=[[formatter stringFromDate:date] intValue];
    
    [formatter setDateFormat:@"hh:mm:ss"];
    
    NSString *time=[formatter stringFromDate:date];
    NSString *result=nil;    
    if(hour>=6&&hour<=11)
    {
        result=[NSString stringWithFormat:@"早上 %@",time];
    }else if(hour<6&&hour>19)
    {
        result=[NSString stringWithFormat:@"晚上 %@",time];   
    }else  if(hour>11&&hour<=14){
        result=[NSString stringWithFormat:@"中午 %@",time];
    }else 
    {
        result=[NSString stringWithFormat:@"下午 %@",time];
    }
    NSLog(@"result=%@",result);
    return result;
}

#pragma mark button按钮点击,切换键盘为表情或者键盘
-(void) changeKeyBoard:(UIButton*) button
{
    
    if (!flag){
        TSEmojiView *emojiView=[[TSEmojiView alloc]initWithFrame:CGRectMake(0, 280, 320, 200)];
        emojiView.delegate=self; 
        
        button.selected=YES;
        [emojiView setBackgroundColor:[UIColor blackColor]];
        //这里需要先放弃第一响应者，然后设置它的inputview属性  
        [field resignFirstResponder];
        [field setInputView:emojiView];
            [field becomeFirstResponder];
        flag=YES;
    }else
    {
        //让自定义的键盘为空，这样就可以让自带的键盘显示
        //NSLog(@"ok");
        button.selected=NO;
        [field resignFirstResponder];
        [field setInputView:nil];
        [field becomeFirstResponder];
        flag=NO;
    }
}



-(void) didTouchEmojiView:(TSEmojiView *)emojiView touchedEmoji:(NSString *)string
{
    field.text=[field.text stringByAppendingFormat:string];
}

-(void) question:(UIButton*) button
{
    QuestionController *controller=[[QuestionController alloc]init];
    [self.navigationController pushViewController:controller animated:YES];
}
-(void) back:(UIButton*) button
{
    sendModel=[_messages lastObject];
    [self.delegate senMessage:sendModel];
    [self.navigationController popViewControllerAnimated:YES];
}

-(void) customReloadView
{
    cellHeight=0;
    [self.tableView reloadData];
}
@end
