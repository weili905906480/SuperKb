//
//  NoteMesController.m
//  MyNotes
//
//  Created by weili on 14-9-14.
//  Copyright (c) 2014年 __MyCompanyName__. All rights reserved.
//

#import "NoteMesController.h"
#import "KGNotePad.h"
#import "ARLabel.h"
#import "SelectTNoteType.h"
#import "TSEmojiView.h"
#import "NoteService.h"
@interface NoteMesController () {
@private
    ARLabel *head;  
}
@end

@implementation NoteMesController
@synthesize noteType=_noteType;
@synthesize noteDelegate=_noteDelegate;
@synthesize edit=_edit;
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        UIBarButtonItem *rightButton=[[UIBarButtonItem alloc]initWithTitle:@"保存" style:UIBarButtonItemStyleBordered target:self action:@selector(store:)];
        self.hidesBottomBarWhenPushed=YES;
        self.navigationItem.rightBarButtonItem=rightButton;
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

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //使用通知来接受消息
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(getNoteTitle:) name:@"noteType" object:nil];
    
    
    UIButton *button=[[UIButton alloc]initWithFrame:CGRectMake(0, 0, 300, 35)];
    [button addTarget:self action:@selector(selectType:) forControlEvents:UIControlEventTouchUpInside];
    head=[[ARLabel alloc]initWithFrame:CGRectMake(40, 10, 0, 20)];
    
    head.textAlignment=UITextAlignmentCenter;
    [self.view addSubview:button];
    [button addSubview:head];
    [UIView animateWithDuration:2 animations:^() {
        head.frame=CGRectMake(40, 10, 240, 20);
    }];
    
    //UITextView *textView=[[UITextView alloc]initWithFrame:CGRectMake(0, 0, 320, 400)];
    textView=[[KGNotePad alloc]initWithFrame:CGRectMake(0, 40, 320, 400)];
    
    if(!_edit){
        head.text=@"点击选择记录类型";
    }else
    {
        head.text=_edit.title;
        textView.textView.text=_edit.detailMessage;
    }
    
    textView.textView.textColor=[UIColor redColor]; 
    //textView.textView.textAlignment
    //设置字体的大小
    textView.verticalLineColor=[UIColor blackColor];
    textView.horizontalLineColor=[UIColor clearColor];
    textView.textView.delegate=self;
    [textView.textView setFont:[UIFont systemFontOfSize:24]];
    textView.textView.contentSize=CGSizeMake(320, 500);
    [self.view addSubview:textView];
  
    //设定检测字体的类型
    textView.textView.dataDetectorTypes=UIDataDetectorTypeAll;    
    //[textView.textView setInputAccessoryView:emojiView];
    
    //UIButton
    //这是一个键盘的辅助视图
    UIView *accessory=[[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 30)];
    accessory.backgroundColor=[UIColor grayColor];
    [textView.textView setInputAccessoryView:accessory];
    UIButton *keyBoard=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    keyBoard.frame=CGRectMake(220, 2, 40, 25);
    [keyBoard setTitle:@"表情" forState:UIControlStateNormal];
    keyBoard.tag=103;
    [keyBoard addTarget:self action:@selector(changeKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    [accessory addSubview:keyBoard];
    
    UIButton *emoji=[UIButton buttonWithType:UIButtonTypeRoundedRect];
    emoji.frame=CGRectMake(270, 2, 40, 25);
    emoji.tag=104;
    
    [emoji addTarget:self action:@selector(changeKeyBoard:) forControlEvents:UIControlEventTouchUpInside];
    [emoji setTitle:@"键盘" forState:UIControlStateNormal];
    [accessory addSubview:emoji];    
}


- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) store:(UIBarButtonItem*) button
{
    [textView.textView resignFirstResponder];
    //这里如果不使用arc，那么这个view将会被释放掉
    //[self.view addSubview:emojiView];
    //滚动到顶部
    [textView.textView setContentSize:CGSizeMake(320, 500)];
    [textView.textView setContentOffset:CGPointMake(0, 0)];
 
    NoteModel *model=[[NoteModel alloc]init];
     model.detailMessage=textView.textView.text;
    if([head.text isEqualToString:@"点击选择记录类型"])
    {
        model.title=@"默认";
    }else{
        model.title=head.text;
    }    
    if(!_edit){
    NSDate *date=[NSDate date];
    NSDateFormatter *formatter=[[NSDateFormatter alloc]init];
   [formatter setDateFormat:@"hh:mm"];
    NSString *time=[formatter stringFromDate:date];
    [formatter setDateFormat:@"yyyy-MM-dd"];
    NSString *year=[formatter stringFromDate:date];
    model.time=time;
    model.yearAndmonth=year;
        [self.noteDelegate addNote:model isModify:NO];
   
    }else{
        model.time=_edit.time;
        model.yearAndmonth=_edit.yearAndmonth;
        [self.noteDelegate addNote:model isModify:YES]; 
    }

   
     
   [self.navigationController popViewControllerAnimated:YES];     
}

#pragma textView delegate
-(void) textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"编辑结束");
}
-(void) textViewDidBeginEditing:(UITextView *)text
{
    
    if([text.text isEqualToString:@""])
    {
        text.text=@"     ";
    }    
    
}

-(void) textViewDidChangeSelection:(UITextView *)text
{
    NSLog(@"selectChange");
    //NSInteger textLocation=text.selectedRange.location;
    CGPoint cursorPosition = [text caretRectForPosition:text.selectedTextRange.start].origin;    

    if(cursorPosition.y>90)
    {
        [text setContentOffset:CGPointMake(0, (cursorPosition.y-66)) animated:YES];
        flag=YES;
    }
}


//文本内容改变
-(void) textViewDidChange:(UITextView *)text
{
    //如果前后的y不一样就去判断，然后滚动
    CGPoint cursorPosition = [text caretRectForPosition:text.selectedTextRange.start].origin;    
     if(current!=0&&current!=cursorPosition.y)
     {
         if(cursorPosition.y>90)
         {
             [text setContentOffset:CGPointMake(0, cursorPosition.y-66) animated:NO];
         }
     }
    current=cursorPosition.y;
}

#pragma emojiTextView delegate
-(void)  didTouchEmojiView:(TSEmojiView *)emojiView touchedEmoji:(NSString *)string
{
    //textView.textView.text=[NSString stringWithFormat:@"%@%@",textView.textView.text,string];
    //在current这个地方插入这个表情
    int currentLocation=textView.textView.selectedRange.location;
    NSString *insertString=[NSString stringWithFormat:@"%@%@%@",[textView.textView.text substringToIndex:currentLocation],string,[textView.textView.text substringFromIndex:currentLocation]];
    textView.textView.text=insertString;
    //这里让光标的位置向后移动一位
    NSLog(@"currentLocation=%d",currentLocation);
    textView.textView.selectedRange=NSMakeRange(currentLocation+1, 0);
    
}

-(void) changeKeyBoard:(UIButton*) button
{
    
    if (button.tag==103){
    TSEmojiView *emojiView=[[TSEmojiView alloc]initWithFrame:CGRectMake(0, 280, 320, 200)];
    emojiView.delegate=self; 
    [emojiView setBackgroundColor:[UIColor blackColor]];
      //这里需要先放弃第一响应者，然后设置它的inputview属性  
    [textView.textView resignFirstResponder];
    [textView.textView setInputView:emojiView];   
    [textView.textView becomeFirstResponder];
    }else
    {
        //让自定义的键盘为空，这样就可以让自带的键盘显示
        //NSLog(@"ok");
        [textView.textView resignFirstResponder];
        [textView.textView setInputView:nil];
        [textView.textView becomeFirstResponder];
    }
}

#pragma button 点击事件
-(void) selectType:(UIButton*) button
{
    SelectTNoteType *contro=[[SelectTNoteType alloc]init];
    _noteType=@"";
    head.text=@"";
    [self.navigationController pushViewController:contro animated:YES];
}

#pragma 收到通知执行的方法
-(void)  getNoteTitle:(NSNotification*) notifition
{
    if(_noteType&&![_noteType isEqualToString:@""])
    {
        _noteType =[_noteType stringByAppendingFormat:@"-%@",notifition.object];
    }else
    {
        _noteType=notifition.object;
    }
    head.text=_noteType;
}


@end
