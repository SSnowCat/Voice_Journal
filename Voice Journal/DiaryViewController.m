//
//  DiaryViewController.m
//  Voice Journal
//
//  Created by Joe on 16/4/22.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "DiaryViewController.h"
#import "TimeLineViewController.h"
#import "EditViewController.h"

@interface DiaryViewController ()
@property (strong, nonatomic) IBOutlet UILabel *tag5;
@property (strong, nonatomic) IBOutlet UIImageView *img5;
@property (strong, nonatomic) IBOutlet UILabel *tag4;
@property (strong, nonatomic) IBOutlet UIImageView *img4;
@property (strong, nonatomic) IBOutlet UILabel *tag3;
@property (strong, nonatomic) IBOutlet UIImageView *img3;
@property (strong, nonatomic) IBOutlet UILabel *tag2;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *tagIcon;
@property (strong, nonatomic) IBOutlet UILabel *week;
@property (strong, nonatomic) IBOutlet UIImageView *imgView;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *time;
@property (strong, nonatomic) IBOutlet UILabel *tag1;
@property (strong, nonatomic) IBOutlet UIButton *playBtn;
@property (strong, nonatomic) IBOutlet UIImageView *starred;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件
@property (nonatomic, strong) UIButton *photobtn;
@property (nonatomic, strong) UIButton *recordbtn;
@property (nonatomic, strong) UIButton *tagbtn;
@property (nonatomic, strong) UIButton *starbtn;
@property (nonatomic, strong) UILabel *tagsLabel;
@property (nonatomic, assign) NSString *starclickCount;
@property (nonatomic, strong) NSMutableArray *tagsArr;
@end

@implementation DiaryViewController
- (IBAction)play:(id)sender {
    if (!_audioPlayer) {
        NSURL *url=[NSURL fileURLWithPath:[self.setting objectAtIndex:1]];
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops=0;
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
    }
    [self.audioPlayer play];
}

-(NSString *)getWeek{
    NSString* string = self.title;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy年 MM月 dd日"];
    NSDate* inputDate = [inputFormatter dateFromString:string];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"EEEE"];
    NSString *week = [outputFormatter stringFromDate:inputDate];
    return week;
}
- (void)keyboardDidShow:(NSNotification *)notification{
    NSDictionary *userInfo = [notification userInfo];
    CGSize keyboardSize = [[userInfo objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    self.textView.frame = CGRectMake(0, 105, self.view.frame.size.width, self.view.frame.size.height-keyboardSize.height-100);
}

-(void)initUI{
    self.textView.editable = NO;
    if ([[self.setting objectAtIndex:0] isEqualToString:@" "]) {
        self.imgView.hidden = YES;
        self.textView.frame = CGRectMake(10,0, self.view.frame.size.width-20, self.view.frame.size.height - 118);
    }else{
        NSData *data = [NSData dataWithContentsOfFile:[self.setting objectAtIndex:0]];
        self.imgView.image = [UIImage imageWithData:data];
    }
    if ([[self.setting objectAtIndex:1] isEqualToString:@" "]) {
        self.playBtn.hidden = YES;
    }
    if ([[self.setting objectAtIndex:2] isEqualToString:@" "]) {
        self.textView.text = @"无文字内容";
    }else{
        NSString *text = [NSString stringWithContentsOfFile:[self.setting objectAtIndex:2] encoding:NSUTF8StringEncoding error:nil];
        self.textView.text = text;
    }
    if ([[self.setting objectAtIndex:3] isEqualToString:@"0"]) {
        self.starred.hidden = YES;
    }
    if ([[self.setting objectAtIndex:6] isEqualToString:@" "]) {
        self.tagIcon.hidden = YES;
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
    }else{
        NSString *path = [NSString stringWithFormat:@"%@",[self.setting objectAtIndex:6]];
        self.tagsArr = [[NSMutableArray alloc]initWithContentsOfFile:path];
        if (self.tagsArr.count == 0) {
            self.tagIcon.hidden = YES;
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
        }else{
            switch (self.tagsArr.count) {
                case 1:
                    self.tag1.text = [self.tagsArr objectAtIndex:0];
                    self.img2.hidden = YES;
                    self.img3.hidden = YES;
                    self.img4.hidden = YES;
                    self.img5.hidden = YES;
                    self.tag2.hidden = YES;
                    self.tag3.hidden = YES;
                    self.tag4.hidden = YES;
                    self.tag5.hidden = YES;
                    break;
                case 2:
                    self.tag1.text = [self.tagsArr objectAtIndex:0];
                    self.tag2.text = [self.tagsArr objectAtIndex:1];
                    self.img3.hidden = YES;
                    self.img4.hidden = YES;
                    self.img5.hidden = YES;
                    self.tag3.hidden = YES;
                    self.tag4.hidden = YES;
                    self.tag5.hidden = YES;
                    break;
                case 3:
                    self.tag1.text = [self.tagsArr objectAtIndex:0];
                    self.tag2.text = [self.tagsArr objectAtIndex:1];
                    self.tag3.text = [self.tagsArr objectAtIndex:2];
                    self.img4.hidden = YES;
                    self.img5.hidden = YES;
                    self.tag4.hidden = YES;
                    self.tag5.hidden = YES;
                    break;
                case 4:
                    self.tag1.text = [self.tagsArr objectAtIndex:0];
                    self.tag2.text = [self.tagsArr objectAtIndex:1];
                    self.tag3.text = [self.tagsArr objectAtIndex:2];
                    self.tag4.text = [self.tagsArr objectAtIndex:3];
                    self.img5.hidden = YES;
                    self.tag5.hidden = YES;
                    break;
                default:
                    self.tag1.text = [self.tagsArr objectAtIndex:0];
                    self.tag2.text = [self.tagsArr objectAtIndex:1];
                    self.tag3.text = [self.tagsArr objectAtIndex:2];
                    self.tag4.text = [self.tagsArr objectAtIndex:3];
                    self.tag5.text = [self.tagsArr objectAtIndex:4];
                    break;
            }
        }

    }
    self.time.text = [self.setting objectAtIndex:5];
    self.week.text = [self getWeek];
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
    self.title = [self.setting objectAtIndex:4];
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0f],UITextAttributeFont,[UIColor whiteColor],UITextAttributeTextColor,nil]];
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
