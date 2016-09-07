//
//  ReviseViewController.m
//  Voice Journal
//
//  Created by Joe on 16/5/3.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "ReviseViewController.h"
#import "TimeLineViewController.h"
#import "Record.h"
#import "RecordViewController.h"
#import "ImgUtil.h"
#define MAX_STARWORDS_LENGTH 5
@interface ReviseViewController ()
@property (strong, nonatomic) IBOutlet UILabel *editTime;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UILabel *tag1;
@property (strong, nonatomic) IBOutlet UIButton *del1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UILabel *tag2;
@property (strong, nonatomic) IBOutlet UIButton *del2;
@property (strong, nonatomic) IBOutlet UIImageView *img3;
@property (strong, nonatomic) IBOutlet UILabel *tag3;
@property (strong, nonatomic) IBOutlet UIButton *del3;
@property (strong, nonatomic) IBOutlet UIImageView *img4;
@property (strong, nonatomic) IBOutlet UILabel *tag4;
@property (strong, nonatomic) IBOutlet UIButton *del4;
@property (strong, nonatomic) IBOutlet UIImageView *img5;
@property (strong, nonatomic) IBOutlet UILabel *tag5;
@property (strong, nonatomic) IBOutlet UIButton *del5;
@property (strong, nonatomic) IBOutlet UITextView *editView;
@property (strong, nonatomic) NSString *textPath;
@property (nonatomic, strong) UIButton *photobtn;
@property (nonatomic, strong) UIButton *recordbtn;
@property (nonatomic, strong) UIButton *tagbtn;
@property (nonatomic, strong) UIButton *starbtn;
@property (nonatomic, strong) UILabel *tagsLabel;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) Record *record;
@end

@implementation ReviseViewController
- (IBAction)backToTimeLine:(id)sender {
    TimeLineViewController *TVC = [self.storyboard instantiateViewControllerWithIdentifier:@"forth_id"];
    TVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:TVC animated:YES completion:nil];
}
- (IBAction)done:(id)sender {
    [self saveData];
    TimeLineViewController *TVC = [self.storyboard instantiateViewControllerWithIdentifier:@"forth_id"];
    TVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:TVC animated:YES completion:nil];
}
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
-(void)settagsLabel{
    if (self.tagsArr.count == 0) {
        [self.tagbtn setImage:[UIImage imageNamed:@"Tags Icon Copy 3@2x.png"] forState:UIControlStateNormal];
        self.del1.hidden = YES;
        self.del2.hidden = YES;
        self.del3.hidden = YES;
        self.del4.hidden = YES;
        self.del5.hidden = YES;
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
                self.del1.hidden = NO;
                self.del2.hidden = YES;
                self.del3.hidden = YES;
                self.del4.hidden = YES;
                self.del5.hidden = YES;
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
                self.del1.hidden = NO;
                self.del2.hidden = NO;
                self.del3.hidden = YES;
                self.del4.hidden = YES;
                self.del5.hidden = YES;
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
                self.del1.hidden = NO;
                self.del2.hidden = NO;
                self.del3.hidden = NO;
                self.del4.hidden = YES;
                self.del5.hidden = YES;
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
                self.del1.hidden = NO;
                self.del2.hidden = NO;
                self.del3.hidden = NO;
                self.del4.hidden = NO;
                self.del5.hidden = YES;
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
                self.del1.hidden = NO;
                self.del2.hidden = NO;
                self.del3.hidden = NO;
                self.del4.hidden = NO;
                self.del5.hidden = NO;
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
- (void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.editView.frame = CGRectMake(0, 105, self.view.frame.size.width, self.view.frame.size.height-keyboardSize.height-100);
}
-(void)keyboardDidHide{
    self.editView.frame = CGRectMake(0, 105, self.view.frame.size.width, self.view.frame.size.height-10);
}
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    [self.editView resignFirstResponder];
}
-(void)saveData{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *tagsPath = [NSString stringWithFormat:@"%@/%@/%@/tags.txt",[self.record getDoc],self.bigDocName,self.smallDocName];
    if (self.recordPath != nil) {
        NSData *data = [NSData dataWithContentsOfFile:self.recordPath];
        self.voicePath = [NSString stringWithFormat:@"%@/%@/%@/%@.caf",[self.record getDoc],self.bigDocName,self.smallDocName,self.editTime.text];
        [fm createFileAtPath:self.voicePath contents:data attributes:nil];
    }else{
        self.voicePath = @" ";
    }
    if (self.tagsArr.count > 0) {
        [fm createFileAtPath:tagsPath contents:nil attributes:nil];
        [self.tagsArr writeToFile:tagsPath atomically:YES];
    }else{
        if (![[self.setting objectAtIndex:6] isEqualToString:@" "]) {
            [fm removeItemAtPath:[NSString stringWithFormat:@"%@/%@/%@/tags.txt",[self.record getDoc],self.bigDocName,self.smallDocName] error:nil];
        }
        NSLog(@"%@",self.tagsArr);
        tagsPath = @" ";
    }
    if (self.editView.text.length>0) {
        self.textPath = [NSString stringWithFormat:@"%@/%@/%@/%@.txt",[self.record getDoc],self.bigDocName,self.smallDocName,self.editTime.text];
        [self.editView.text writeToFile:self.textPath atomically:YES encoding:NSUTF8StringEncoding error:nil];
    }else{
        self.textPath = @" ";
    }
    NSString *subtime = [self.setting objectAtIndex:5];
    NSArray *setting = @[self.imgPath,self.voicePath,self.textPath,self.starclickCount,self.editTime.text,subtime,tagsPath];
    [setting writeToFile:[NSString stringWithFormat:@"%@/%@/%@/setting.txt",[self.record getDoc],self.bigDocName,self.smallDocName] atomically:YES];
    [fm removeItemAtPath:self.recordPath error:nil];
    NSLog(@"%@",setting);
}
-(void)initUI{
    NSLog(@"%@",self.setting);
    self.picker = [[UIImagePickerController alloc]init];
    self.record = [[Record alloc]init];
    [self.editView becomeFirstResponder];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide) name:UIKeyboardWillHideNotification object:nil];
    UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 50, 60)];
    customView.backgroundColor = [UIColor whiteColor];
    self.editView.inputAccessoryView = customView;
    self.recordbtn = [[UIButton alloc] initWithFrame:CGRectMake(50, 5, 50, 50)];
    self.tagbtn = [[UIButton alloc] initWithFrame:CGRectMake(120, 5, 50, 50)];
    self.tagsLabel = [[UILabel alloc] initWithFrame:CGRectMake(171, 10, 10, 10)];
    self.photobtn = [[UIButton alloc] initWithFrame:CGRectMake(190, 5, 50, 50)];
    self.starbtn = [[UIButton alloc] initWithFrame:CGRectMake(260, 5, 50, 50)];
    if ([self.rootView isEqualToString:@"Revise"]) {
        self.editTime.text = [self.setting objectAtIndex:4];
        NSLog(@"%@",self.starclickCount);
        self.editView.text = self.contentText;
        [self settagsLabel];
        if ([self.imgPath isEqualToString:@" "]) {
            [self.photobtn setImage:[UIImage imageNamed:@"Camera Copy@2x.png"] forState:UIControlStateNormal];
        }else{
            [self.photobtn setImage:[UIImage imageNamed:@"Camera@2x.png"] forState:UIControlStateNormal];
        }
        if ([self.starclickCount isEqualToString:@"0"]) {
            [self.starbtn setImage:[UIImage imageNamed:@"Starred Icon Copy@3x.png"] forState:UIControlStateNormal];
        }
        if ([self.starclickCount isEqualToString:@"1"]) {
            [self.starbtn setImage:[UIImage imageNamed:@"Starred@2x.png"] forState:UIControlStateNormal];
        }
        if (self.recordPath == nil) {
            [self.recordbtn setImage:[UIImage imageNamed:@"Triangle 1 Copy 3@2x.png"] forState:UIControlStateNormal];
        }else{
            [self.recordbtn setImage:[UIImage imageNamed:@"Triangle 1 Copy2@2x.png"] forState:UIControlStateNormal];
        }
        
    }else{
        self.imgPath = [self.setting objectAtIndex:0];
        self.voicePath = [self.setting objectAtIndex:1];
        self.textPath = [self.setting objectAtIndex:2];
        self.starclickCount = [self.setting objectAtIndex:3];
        self.editTime.text = [self.setting objectAtIndex:4];
        NSLog(@"%@",self.starclickCount);
        if (self.contentText == nil) {
            if (![self.textPath isEqualToString:@" "]) {
                NSString *text = [NSString stringWithContentsOfFile:self.textPath encoding:NSUTF8StringEncoding error:nil];
                self.editView.text = text;
            }
        }else{
            self.editView.text = self.contentText;
        }
        if ([[self.setting objectAtIndex:6] isEqualToString:@" "]) {
            [self.tagbtn setImage:[UIImage imageNamed:@"Tags Icon Copy 3@2x.png"] forState:UIControlStateNormal];
            self.tagsArr = [[NSMutableArray alloc]init];
            self.del1.hidden = YES;
            self.del2.hidden = YES;
            self.del3.hidden = YES;
            self.del4.hidden = YES;
            self.del5.hidden = YES;
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
            NSString *path = [NSString stringWithFormat:@"%@",[self.setting objectAtIndex:6]];
            self.tagsArr = [[NSMutableArray alloc]initWithContentsOfFile:path];
            [self settagsLabel];
        }
        if ([self.imgPath isEqualToString:@" "]) {
            [self.photobtn setImage:[UIImage imageNamed:@"Camera Copy@2x.png"] forState:UIControlStateNormal];
        }else{
            [self.photobtn setImage:[UIImage imageNamed:@"Camera@2x.png"] forState:UIControlStateNormal];
        }
        if ([self.starclickCount isEqualToString:@"0"]) {
            [self.starbtn setImage:[UIImage imageNamed:@"Starred Icon Copy@3x.png"] forState:UIControlStateNormal];
        }
        if ([self.starclickCount isEqualToString:@"1"]) {
            [self.starbtn setImage:[UIImage imageNamed:@"Starred@2x.png"] forState:UIControlStateNormal];
        }
        if ([self.voicePath isEqualToString:@" "]) {
            [self.recordbtn setImage:[UIImage imageNamed:@"Triangle 1 Copy 3@2x.png"] forState:UIControlStateNormal];
        }else{
            [self.recordbtn setImage:[UIImage imageNamed:@"Triangle 1 Copy2@2x.png"] forState:UIControlStateNormal];
        }
    }
    self.tagsLabel.textColor = [UIColor colorWithRed:175.0/255.0 green:85.0/255.0 blue:106.0/255.0 alpha:1.0];
    self.tagsLabel.font = [UIFont systemFontOfSize:11.0];
    self.tagsLabel.adjustsFontSizeToFitWidth = YES;
    [self.recordbtn addTarget:self action:@selector(pushtoRecord) forControlEvents:UIControlEventTouchUpInside];
    [self.photobtn addTarget:self action:@selector(pushtoPhoto) forControlEvents:UIControlEventTouchUpInside];
    [self.tagbtn addTarget:self action:@selector(tag) forControlEvents:UIControlEventTouchUpInside];
    [self.starbtn addTarget:self action:@selector(star) forControlEvents:UIControlEventTouchUpInside];
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
        NSLog(@"%@",self.tagsArr);
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
    NSFileManager *fm = [NSFileManager defaultManager];
    if ([self.imgPath isEqualToString:@" "]) {
        self.imgPath = [NSString stringWithFormat:@"%@/%@/%@/%@.png",[self.record getDoc],self.bigDocName,self.smallDocName,self.editTime.text];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        [alert addAction:[UIAlertAction actionWithTitle:@"Take Photo" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            // 设置照片来源为相机
            self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
            // 设置进入相机时使用前置或后置摄像头
            self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
            self.picker.delegate = self;
            self.picker.allowsEditing = YES;
            // 展示选取照片控制器
            [self presentViewController:self.picker animated:YES completion:^{}];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Choose from Library" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self LocalPhoto];
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:^(UIAlertAction * _Nonnull action) {
            nil;
        }]];
        alert.view.tintColor = [UIColor colorWithRed:169.0/255.0 green:211.0/255.0 blue:230.0/255.0 alpha:1.0];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认删除照片" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.photobtn setImage:[UIImage imageNamed:@"Camera Copy@2x.png"] forState:UIControlStateNormal];
            [fm removeItemAtPath:self.imgPath error:nil];
            self.imgPath = @" ";
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
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
        [fm createFileAtPath:self.imgPath contents:data attributes:nil];
        if (![self.imgPath isEqualToString:@" "]) {
            [self.photobtn setImage:[UIImage imageNamed:@"Camera@2x.png"] forState:UIControlStateNormal];
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
    if ([self.voicePath isEqualToString:@" "]) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *recordAction = [UIAlertAction actionWithTitle:@"New Record" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            RecordViewController *RVC = [self.storyboard instantiateViewControllerWithIdentifier:@"second_id"];
            RVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            RVC.imgPath = self.imgPath;
            RVC.text = self.editView.text;
            RVC.tagsArr = self.tagsArr;
            RVC.isStarred = self.starclickCount;
            RVC.rootView = @"Revise";
            RVC.setting = self.setting;
            RVC.bigDocName = self.bigDocName;
            RVC.smallDocName = self.smallDocName;
            [self presentViewController:RVC animated:YES completion:nil];
        }];
        UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
        [alert addAction:recordAction];
        [alert addAction:cancelAction];
        alert.view.tintColor = [UIColor colorWithRed:169.0/255.0 green:211.0/255.0 blue:230.0/255.0 alpha:1.0];
        [self presentViewController:alert animated:YES completion:nil];
    }else{
        NSFileManager *fm = [NSFileManager defaultManager];
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"温馨提示" message:@"确认删除录音" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
        [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.recordbtn setImage:[UIImage imageNamed:@"Triangle 1 Copy 3@2x.png"] forState:UIControlStateNormal];
            if (self.recordPath != nil) {
                [fm removeItemAtPath:self.recordPath error:nil];
                self.recordPath = nil;
            }
            [fm removeItemAtPath:self.voicePath error:nil];
            self.voicePath = @" ";
        }]];
        [self presentViewController:alert animated:YES completion:nil];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
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
