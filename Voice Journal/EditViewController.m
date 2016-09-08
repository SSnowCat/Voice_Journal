//
//  EditViewController.m
//  Voice Journal
//
//  Created by Joe on 16/4/17.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "EditViewController.h"
#import "TimeLineViewController.h"
#import "RecordViewController.h"
#import "Record.h"
#import "ImgUtil.h"

#define MAX_STARWORDS_LENGTH 5
@interface EditViewController ()
@property (strong, nonatomic) IBOutlet UITextView *editView;
@property (strong, nonatomic) IBOutlet UIImageView *lineView;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UIImageView *img3;
@property (strong, nonatomic) IBOutlet UIImageView *img4;
@property (strong, nonatomic) IBOutlet UIImageView *img5;
@property (strong, nonatomic) IBOutlet UILabel *tag1;
@property (strong, nonatomic) IBOutlet UILabel *tag2;
@property (strong, nonatomic) IBOutlet UILabel *tag3;
@property (strong, nonatomic) IBOutlet UILabel *tag4;
@property (strong, nonatomic) IBOutlet UILabel *tag5;
@property (strong, nonatomic) IBOutlet UIButton *del1btn;
@property (strong, nonatomic) IBOutlet UIButton *del2btn;
@property (strong, nonatomic) IBOutlet UIButton *del3btn;
@property (strong, nonatomic) IBOutlet UIButton *del4btn;
@property (strong, nonatomic) IBOutlet UIButton *del5btn;
@property (nonatomic, strong) Record *record;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) UIButton *photobtn;
@property (nonatomic, strong) UIButton *recordbtn;
@property (nonatomic, strong) UIButton *tagbtn;
@property (nonatomic, strong) UIButton *starbtn;
@property (nonatomic, strong) UILabel *tagsLabel;
@property (nonatomic, assign) int haveDoc;
@property (nonatomic, strong) NSString *bigDocPath;
@property (nonatomic, strong) NSString *newimgpath;
@property (nonatomic, strong) NSString *newrecordpath;
@property (nonatomic, strong) NSString *textpath;
@property (nonatomic, strong) NSString *tagsPath;
@property (nonatomic, assign) int photoclick;
@end

@implementation EditViewController
- (IBAction)del1:(id)sender {
    [self.tagsArr removeObjectAtIndex:0];
    [self settagsLabel];
    if (self.tagsArr.count == 0) {
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Icon Copy 3@2x.png"] forState:UIControlStateNormal];
        self.tagsLabel.hidden = YES;
    }else{
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Added@3x.png"] forState:UIControlStateNormal];
        self.tagsLabel.hidden = NO;
        self.tagsLabel.text = [NSString stringWithFormat:@"%lu",self.tagsArr.count];
    }
}
- (IBAction)del2:(id)sender {
    [self.tagsArr removeObjectAtIndex:1];
    [self settagsLabel];
    if (self.tagsArr.count == 0) {
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Icon Copy 3@2x.png"] forState:UIControlStateNormal];
        self.tagsLabel.hidden = YES;
    }else{
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Added@3x.png"] forState:UIControlStateNormal];
        self.tagsLabel.hidden = NO;
        self.tagsLabel.text = [NSString stringWithFormat:@"%lu",self.tagsArr.count];
    }
}
- (IBAction)del3:(id)sender {
    [self.tagsArr removeObjectAtIndex:2];
    [self settagsLabel];
    if (self.tagsArr.count == 0) {
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Icon Copy 3@2x.png"] forState:UIControlStateNormal];
        self.tagsLabel.hidden = YES;
    }else{
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Added@3x.png"] forState:UIControlStateNormal];
        self.tagsLabel.hidden = NO;
        self.tagsLabel.text = [NSString stringWithFormat:@"%lu",self.tagsArr.count];
    }
}
- (IBAction)del4:(id)sender {
    [self.tagsArr removeObjectAtIndex:3];
    [self settagsLabel];
    if (self.tagsArr.count == 0) {
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Icon Copy 3@2x.png"] forState:UIControlStateNormal];
        self.tagsLabel.hidden = YES;
    }else{
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Added@3x.png"] forState:UIControlStateNormal];
        self.tagsLabel.hidden = NO;
        self.tagsLabel.text = [NSString stringWithFormat:@"%lu",self.tagsArr.count];
    }
}
- (IBAction)del5:(id)sender {
    [self.tagsArr removeObjectAtIndex:4];
    [self settagsLabel];
    if (self.tagsArr.count == 0) {
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Icon Copy 3@2x.png"] forState:UIControlStateNormal];
        self.tagsLabel.hidden = YES;
    }else{
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Added@3x.png"] forState:UIControlStateNormal];
        self.tagsLabel.hidden = NO;
        self.tagsLabel.text = [NSString stringWithFormat:@"%lu",self.tagsArr.count];
    }
}
-(NSArray *)getDocList{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fileList = [fm contentsOfDirectoryAtPath:[self.record getDoc] error:nil];
    NSMutableArray *dirArray = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *path = [[self.record getDoc] stringByAppendingPathComponent:file];
        [fm fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [dirArray addObject:file];
        }
        isDir = NO;
    }
    return dirArray;
}

-(void)saveData{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *text = self.editView.text;
    NSString *bigDocName = [self.title substringToIndex:9];
    NSString *time = [self time];
    NSRange range = NSMakeRange(2, 6);
    NSString *subtime = [time substringWithRange:range];
    NSArray *docList = [self getDocList];
    for (NSString *docName in docList) {
        if ([docName isEqualToString:bigDocName]) {
            self.haveDoc = 1;
        }
    }
    if (self.haveDoc == 0) {
        [self.record createDirWithName:bigDocName];
    }
    self.bigDocPath = [NSString stringWithFormat:@"%@/%@",[self.record getDoc],bigDocName];
    NSString *smallDocName = [NSString stringWithFormat:@"%@ %@",[self.title substringFromIndex:10],time];
    NSString *path = [self.bigDocPath stringByAppendingPathComponent:smallDocName];
    [fm createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
    if (self.voicePath != nil) {
        NSString *recordpath = [NSString stringWithFormat:@"%@/%@",[self.record getDoc],self.recordFileName];
        NSData *recorddata = [NSData dataWithContentsOfFile:recordpath];
        self.newrecordpath = [NSString stringWithFormat:@"%@/%@",path,self.recordFileName];
        [fm createFileAtPath:self.newrecordpath contents:recorddata attributes:nil];
    }
    if (self.imgPath != nil) {
        NSString *imgpath = [NSString stringWithFormat:@"%@/%@",[self.record getDoc],self.imgFileName];
        NSData *imgdata = [NSData dataWithContentsOfFile:imgpath];
        self.newimgpath = [NSString stringWithFormat:@"%@/%@",path,self.imgFileName];
        [fm createFileAtPath:self.newimgpath contents:imgdata attributes:nil];
    }
    if (text.length != 0) {
        self.textpath = [NSString stringWithFormat:@"%@/%@.txt",path,self.title];
        [fm createFileAtPath:self.textpath contents:nil attributes:nil];
        [text writeToFile:self.textpath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }
    if (self.tagsArr.count > 0) {
        self.tagsPath = [NSString stringWithFormat:@"%@/tags.txt",path];
        [fm createFileAtPath:self.tagsPath contents:nil attributes:nil];
        [self.tagsArr writeToFile:self.tagsPath atomically:YES];
    }
    if (self.newimgpath == nil) {
        self.newimgpath = @" ";
    }
    if (self.newrecordpath == nil) {
        self.newrecordpath = @" ";
    }
    if (self.textpath == nil) {
        self.textpath = @" ";
    }
    if (self.tagsPath == nil) {
        self.tagsPath = @" ";
    }
    NSArray *setting = @[self.newimgpath,self.newrecordpath,self.textpath,self.starclickCount,self.title,subtime,self.tagsPath];
    [fm createFileAtPath:[NSString stringWithFormat:@"%@/setting.txt",path] contents:nil attributes:nil];
    [setting writeToFile:[NSString stringWithFormat:@"%@/setting.txt",path] atomically:nil];
}
-(void)delFile{
    NSFileManager *fm = [NSFileManager defaultManager];
    [fm removeItemAtPath:self.imgPath error:nil];
    [fm removeItemAtPath:self.voicePath error:nil];
}
- (void)done{
    [self saveData];
    [self delFile];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(void)backMenu{
    [self delFile];
    [self.navigationController popToRootViewControllerAnimated:YES];
}
-(NSString *)getTime{
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy年 MM月 dd日"];
    NSString * na = [df stringFromDate:currentDate];
    return na;
}
-(NSString *)time{
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc]init];
    [df setLocale:[[NSLocale alloc]initWithLocaleIdentifier:@"en_US"]];
    [df setDateFormat:@"a hh:mm:ss"];
    NSString * na = [df stringFromDate:currentDate];
    return na;
}
- (void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.editView.frame = CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height-keyboardSize.height-40);
}
-(void)keyboardDidHide{
    self.editView.frame = CGRectMake(0, 45, self.view.frame.size.width, self.view.frame.size.height-40);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.editView resignFirstResponder];
}
-(void)settagsLabel{
    if (self.tagsArr.count == 0) {
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Icon Copy 3@2x.png"] forState:UIControlStateNormal];
        self.del1btn.hidden = YES;
        self.del2btn.hidden = YES;
        self.del3btn.hidden = YES;
        self.del4btn.hidden = YES;
        self.del5btn.hidden = YES;
        self.img1.hidden = YES;
        self.img2.hidden = YES;
        self.img3.hidden = YES;
        self.img4.hidden = YES;
        self.img5.hidden = YES;
        self.tag1.hidden = YES;
        self.tag2.hidden = YES;
        self.tag3.hidden = YES;
        self.tag4.hidden = YES;
        self.tag5.hidden = YES;
        self.tagbtn.hidden = NO;
        self.tagbtn.enabled = YES;
    }else{
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Added@3x.png"] forState:UIControlStateNormal];
        self.tagsLabel.hidden = NO;
        self.tagsLabel.text = [NSString stringWithFormat:@"%lu",self.tagsArr.count];
        switch (self.tagsArr.count) {
            case 1:
                self.tag1.text = [self.tagsArr objectAtIndex:0];
                self.del1btn.hidden = NO;
                self.del2btn.hidden = YES;
                self.del3btn.hidden = YES;
                self.del4btn.hidden = YES;
                self.del5btn.hidden = YES;
                self.tag1.hidden = NO;
                self.img1.hidden = NO;
                self.img2.hidden = YES;
                self.img3.hidden = YES;
                self.img4.hidden = YES;
                self.img5.hidden = YES;
                self.tag2.hidden = YES;
                self.tag3.hidden = YES;
                self.tag4.hidden = YES;
                self.tag5.hidden = YES;
                self.tagbtn.enabled = YES;
                break;
            case 2:
                self.tag1.text = [self.tagsArr objectAtIndex:0];
                self.tag2.text = [self.tagsArr objectAtIndex:1];
                self.del1btn.hidden = NO;
                self.del2btn.hidden = NO;
                self.del3btn.hidden = YES;
                self.del4btn.hidden = YES;
                self.del5btn.hidden = YES;
                self.img1.hidden = NO;
                self.img2.hidden = NO;
                self.img3.hidden = YES;
                self.img4.hidden = YES;
                self.img5.hidden = YES;
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = YES;
                self.tag4.hidden = YES;
                self.tag5.hidden = YES;
                self.tagbtn.enabled = YES;
                break;
            case 3:
                self.tag1.text = [self.tagsArr objectAtIndex:0];
                self.tag2.text = [self.tagsArr objectAtIndex:1];
                self.tag3.text = [self.tagsArr objectAtIndex:2];
                self.del1btn.hidden = NO;
                self.del2btn.hidden = NO;
                self.del3btn.hidden = NO;
                self.del4btn.hidden = YES;
                self.del5btn.hidden = YES;
                self.img1.hidden = NO;
                self.img2.hidden = NO;
                self.img3.hidden = NO;
                self.img4.hidden = YES;
                self.img5.hidden = YES;
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = NO;
                self.tag4.hidden = YES;
                self.tag5.hidden = YES;
                self.tagbtn.enabled = YES;
                break;
            case 4:
                self.tag1.text = [self.tagsArr objectAtIndex:0];
                self.tag2.text = [self.tagsArr objectAtIndex:1];
                self.tag3.text = [self.tagsArr objectAtIndex:2];
                self.tag4.text = [self.tagsArr objectAtIndex:3];
                self.del1btn.hidden = NO;
                self.del2btn.hidden = NO;
                self.del3btn.hidden = NO;
                self.del4btn.hidden = NO;
                self.del5btn.hidden = YES;
                self.img1.hidden = NO;
                self.img2.hidden = NO;
                self.img3.hidden = NO;
                self.img4.hidden = NO;
                self.img5.hidden = YES;
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = NO;
                self.tag4.hidden = NO;
                self.tag5.hidden = YES;
                self.tagbtn.enabled = YES;
                break;
            default:
                self.tag1.text = [self.tagsArr objectAtIndex:0];
                self.tag2.text = [self.tagsArr objectAtIndex:1];
                self.tag3.text = [self.tagsArr objectAtIndex:2];
                self.tag4.text = [self.tagsArr objectAtIndex:3];
                self.tag5.text = [self.tagsArr objectAtIndex:4];
                self.del1btn.hidden = NO;
                self.del2btn.hidden = NO;
                self.del3btn.hidden = NO;
                self.del4btn.hidden = NO;
                self.del5btn.hidden = NO;
                self.img1.hidden = NO;
                self.img2.hidden = NO;
                self.img3.hidden = NO;
                self.img4.hidden = NO;
                self.img5.hidden = NO;
                self.tag1.hidden = NO;
                self.tag2.hidden = NO;
                self.tag3.hidden = NO;
                self.tag4.hidden = NO;
                self.tag5.hidden = NO;
                self.tagbtn.enabled = NO;
                break;
        }
    }

}

-(void)initUI{
    self.editView.text = self.contentText;
    self.record = [[Record alloc]init];
    self.haveDoc = 0;
    self.picker = [[UIImagePickerController alloc]init];
    [self.editView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 60)];
    customView.backgroundColor = [UIColor clearColor];
    self.editView.inputAccessoryView = customView;
    self.recordbtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.14, 5, 50, 50)];

    self.tagbtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.32, 5, 50, 50)];
    
    self.tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.456, 10, 10, 10)];
    
    self.photobtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.5, 5, 50, 50)];
    
    self.starbtn = [[UIButton alloc] initWithFrame:CGRectMake(self.view.frame.size.width*0.7, 5, 50, 50)];
    
    if (self.voicePath != nil) {
        [self.recordbtn setImage:[UIImage imageNamed:@"Triangle 1 Copy2@2x.png"] forState:UIControlStateNormal];
        self.recordbtn.enabled = NO;
    }else{
        [self.recordbtn setImage:[UIImage imageNamed:@"Triangle 1 Copy 3@2x.png"] forState:UIControlStateNormal];
    }
    if (self.starclickCount == nil) {
        self.starclickCount = @"0";
        [self.starbtn setImage:[UIImage imageNamed:@"Starred Icon Copy@3x.png"] forState:UIControlStateNormal];
    }else{
        if ([self.starclickCount isEqualToString:@"0"]) {
            [self.starbtn setImage:[UIImage imageNamed:@"Starred Icon Copy@3x.png"] forState:UIControlStateNormal];
        }
        else if ([self.starclickCount isEqualToString:@"1"]) {
            [self.starbtn setImage:[UIImage imageNamed:@"Starred@2x.png"] forState:UIControlStateNormal];
        }
    }
    if (self.tagsArr == nil) {
        self.del1btn.hidden = YES;
        self.del2btn.hidden = YES;
        self.del3btn.hidden = YES;
        self.del4btn.hidden = YES;
        self.del5btn.hidden = YES;
        self.img1.hidden = YES;
        self.img2.hidden = YES;
        self.img3.hidden = YES;
        self.img4.hidden = YES;
        self.img5.hidden = YES;
        self.tag1.hidden = YES;
        self.tag2.hidden = YES;
        self.tag3.hidden = YES;
        self.tag4.hidden = YES;
        self.tag5.hidden = YES;
        self.tagbtn.enabled = YES;
        self.tagsArr = [[NSMutableArray alloc]init];
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Icon Copy 3@2x.png"] forState:UIControlStateNormal];
    }else{
        [self settagsLabel];
    }
    if (self.imgPath != nil) {
        [self.photobtn setImage:[UIImage imageNamed:@"Camera@2x.png"] forState:UIControlStateNormal];
        self.photobtn.enabled = NO;
    }else{
        [self.photobtn setImage:[UIImage imageNamed:@"Camera Copy@2x.png"] forState:UIControlStateNormal];
    }
    [self.recordbtn addTarget:self action:@selector(pushtoRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.photobtn addTarget:self action:@selector(pushtoPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.tagbtn addTarget:self action:@selector(tag) forControlEvents:UIControlEventTouchUpInside];
    [self.starbtn addTarget:self action:@selector(star) forControlEvents:UIControlEventTouchUpInside];
    self.tagsLabel.textColor = [UIColor colorWithRed:175.0/255.0 green:85.0/255.0 blue:106.0/255.0 alpha:1.0];
    self.tagsLabel.font = [UIFont systemFontOfSize:11.0];
    self.tagsLabel.adjustsFontSizeToFitWidth = YES;
    [customView addSubview:self.recordbtn];
    [customView addSubview:self.photobtn];
    [customView addSubview:self.tagbtn];
    [customView addSubview:self.tagsLabel];
    [customView addSubview:self.starbtn];
}
-(void)star{
    if ([self.starclickCount isEqualToString:@"0"]) {
        [self.starbtn setImage:[UIImage imageNamed:@"Starred@2x.png"] forState:UIControlStateNormal];
        self.starclickCount = @"1";
    }
    else if ([self.starclickCount isEqualToString:@"1"]) {
        [self.starbtn setImage:[UIImage imageNamed:@"Starred Icon Copy@3x.png"] forState:UIControlStateNormal];
        self.starclickCount = @"0";
    }
}
-(void)tag{
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"添加标签" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        if (self.tagsArr.count > 0) {
            [self settagsLabel];
        }else{
            [self.tagbtn setImage:[UIImage imageNamed:@"Tags Icon Copy 3@2x.png"] forState:UIControlStateNormal];
            self.tagsLabel.hidden = YES;
        }
    }];
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        NSArray *textField = alert.textFields;
        UITextField *tag = textField[0];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        [self.tagsArr addObject:tag.text];
        if (self.tagsArr.count > 0) {
            [self.tagbtn setImage:[UIImage imageNamed:@"Tags Added@3x.png"] forState:UIControlStateNormal];
            self.tagsLabel.hidden = NO;
            self.tagsLabel.text = [NSString stringWithFormat:@"%lu",self.tagsArr.count];
        }else{
            [self.tagbtn setImage:[UIImage imageNamed:@"Tags Icon Copy 3@2x.png"] forState:UIControlStateNormal];
            self.tagsLabel.hidden = YES;
        }
        [self settagsLabel];
        }];
    [alert addAction:cancelAction];
    [alert addAction:saveAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *saveAction = alertController.actions.lastObject;
        saveAction.enabled = login.text.length > 0;
        NSString *toBeString = login.text;
        UITextRange *selectedRange = [login markedTextRange];
        UITextPosition *position = [login positionFromPosition:selectedRange.start offset:0];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        //搜狗百度输入法
        if (!position){
            if (toBeString.length > MAX_STARWORDS_LENGTH){
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
                if (rangeIndex.length == 1){
                    login.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
                }
                else{
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                    login.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
        //获取高亮部分
         NSString *lang = [login.textInputMode primaryLanguage];
        // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
        // 简体中文输入
        if ([lang isEqualToString:@"zh-Hans"]){
            //获取高亮部分
            UITextRange *selectedRange = [login markedTextRange];
            UITextPosition *position = [login positionFromPosition:selectedRange.start offset:0];
            // 没有高亮选择的字，则对已输入的文字进行字数统计和限制
            if (!position){
                if (toBeString.length > MAX_STARWORDS_LENGTH){
                    login.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
                }
            }
        }
        // 中文输入法以外的直接对其统计限制即可，不考虑其他语种情况
        else{
            if (toBeString.length > MAX_STARWORDS_LENGTH){
                NSRange rangeIndex = [toBeString rangeOfComposedCharacterSequenceAtIndex:MAX_STARWORDS_LENGTH];
                if (rangeIndex.length == 1){
                    login.text = [toBeString substringToIndex:MAX_STARWORDS_LENGTH];
                }
                else{
                    NSRange rangeRange = [toBeString rangeOfComposedCharacterSequencesForRange:NSMakeRange(0, MAX_STARWORDS_LENGTH)];
                    login.text = [toBeString substringWithRange:rangeRange];
                }
            }
        }
    }
}
-(void)textFieldEditChanged:(NSNotification *)obj
{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *saveAction = alertController.actions.lastObject;
        saveAction.enabled = login.text.length > 0;
    }
}
-(void)pushtoPhoto{
    //图片保存的路径
    
    self.imgFileName = [NSString stringWithFormat:@"%@.png",self.title];
    self.imagePath = [NSString stringWithFormat:@"%@/%@",[self.record getDoc],self.imgFileName];
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    [alert addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        // 设置照片来源为相机
        self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        // 设置进入相机时使用前置或后置摄像头
        self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
        self.picker.delegate = self;
        self.picker.allowsEditing = YES;
        // 展示选取照片控制器
        [self presentViewController:self.picker animated:YES completion:nil];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Choose from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self LocalPhoto];
    }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
        nil;
    }]];
    alert.view.tintColor = [UIColor colorWithRed:169.0/255.0 green:211.0/255.0 blue:230.0/255.0 alpha:1.0];
    [self presentViewController:alert animated:YES completion:nil];
}
-(void)LocalPhoto{
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    //设置选择后的图片可被编辑
    self.picker.allowsEditing = YES;
    [self presentViewController:self.picker animated:YES completion:nil];
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    //关闭相册界面
    dispatch_async(dispatch_get_main_queue(), ^{
        [self dismissViewControllerAnimated:YES completion:nil];
    });
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]){
        //先把图片转成NSData
        UIImage* imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *image = [ImgUtil fixOrientation:imageOriginal];
        if (self.picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil){
            data = UIImageJPEGRepresentation(image, 1.0);
        }
        else{
            data = UIImagePNGRepresentation(image);
        }
        [fm createFileAtPath:self.imagePath contents:data attributes:nil];
        self.imgPath = self.imagePath;
        if (self.imgPath != nil) {
            [self.photobtn setImage:[UIImage imageNamed:@"Camera@2x.png"] forState:UIControlStateNormal];
            self.photobtn.enabled = NO;
        }else{
            [self.photobtn setImage:[UIImage imageNamed:@"Camera Copy@2x.png"] forState:UIControlStateNormal];
        }
    }
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo{
    if (error) {
        nil;
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(void)pushtoRecord{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *recordAction = [UIAlertAction actionWithTitle:@"New Record" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RecordViewController *RVC = [self.storyboard instantiateViewControllerWithIdentifier:@"second_id"];
        RVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        RVC.imgPath = self.imgPath;
        RVC.text = self.editView.text;
        RVC.imgfilename = self.imgFileName;
        RVC.tagsArr = self.tagsArr;
        RVC.isStarred = self.starclickCount;
        [self.navigationController pushViewController:RVC animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:recordAction];
    [alert addAction:cancelAction];
    alert.view.tintColor = [UIColor colorWithRed:169.0/255.0 green:211.0/255.0 blue:230.0/255.0 alpha:1.0];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Rectangle 14.png"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.title = [self getTime];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0f],UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor,nil]];
    
    UIButton *doneBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 20)];
    [doneBtn setTintColor:[UIColor whiteColor]];
    [doneBtn setTitle:@"Done" forState:UIControlStateNormal];
    doneBtn.titleLabel.font = [UIFont systemFontOfSize:17.0f];
    [doneBtn addTarget:self action:@selector(done) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn1=[[UIBarButtonItem alloc]initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem=barBtn1;
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
