//
//  RecordViewController.m
//  Voice Journal
//
//  Created by Joe on 16/4/5.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "RecordViewController.h"
#import "Record.h"
#import "ViewController.h"
#import "EditViewController.h"


BOOL toggle = NO;
BOOL toggleForStop = NO;

@interface RecordViewController ()
//@property (strong, nonatomic) IBOutlet UILabel *recording;

@property (weak, nonatomic) IBOutlet UILabel *stopLabel;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UILabel *second;
@property (strong, nonatomic) IBOutlet UILabel *minute;
@property (strong, nonatomic) IBOutlet UILabel *hour;
@property (strong, nonatomic) IBOutlet UILabel *timeLabel;
@property (strong, nonatomic) IBOutlet UIButton *play;
@property (strong, nonatomic) IBOutlet UIButton *start;
@property (strong, nonatomic) IBOutlet UIButton *stop;
@property (strong, nonatomic) IBOutlet UIButton *done;
@property (nonatomic, strong) AVAudioRecorder *audioRecorder;//音频录音机
@property (strong, nonatomic) NSString *urlPath;
@property (nonatomic, strong) AVAudioPlayer *audioPlayer;//音频播放器，用于播放录音文件
@property (nonatomic, strong) Record *record;
@property (nonatomic, strong) NSString *filename;
@property (nonatomic, strong) NSString *docName;
@property (nonatomic, strong) NSString *newurlPath;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSTimer *timer1;
@property (nonatomic, assign) int sCount;
@property (nonatomic, assign) int mCount;
@property (nonatomic, assign) int hCount;
@end

@implementation RecordViewController
-(void)setAudioSession{
    AVAudioSession *audioSession=[AVAudioSession sharedInstance];
    //设置为播放和录音状态，以便可以在录制完之后播放录音
    [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:nil];
    [audioSession setActive:YES error:nil];
}
-(NSDictionary *)getAudioSetting{
    NSMutableDictionary *dicM=[NSMutableDictionary dictionary];
    //设置录音格式
    [dicM setObject:@(kAudioFormatLinearPCM) forKey:AVFormatIDKey];
    //设置录音采样率，8000是电话采样率，对于一般录音已经够了
    [dicM setObject:@(8000) forKey:AVSampleRateKey];
    //设置通道,这里采用单声道
    [dicM setObject:@(1) forKey:AVNumberOfChannelsKey];
    //每个采样点位数,分为8、16、24、32
    [dicM setObject:@(8) forKey:AVLinearPCMBitDepthKey];
    //是否使用浮点数采样
    [dicM setObject:@(YES) forKey:AVLinearPCMIsFloatKey];
    //....其他设置等
    return dicM;
}
- (IBAction)cancel:(id)sender {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@.caf",[self.record getDoc],self.urlPath];
    [fm removeItemAtPath:path error:nil];
    [self.navigationController popViewControllerAnimated:YES];
}
- (IBAction)play:(id)sender {
    self.done.enabled = YES;
    self.done.alpha = 1.0;
    [self.play setImage:[UIImage imageNamed:@"Group@2x.png"] forState:UIControlStateNormal];
    NSString * encodingString = [self.urlPath stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    NSString *path = [NSString stringWithFormat:@"%@/%@.caf",[self.record getDoc],encodingString];
    if (!_audioPlayer) {
        NSURL *url=[NSURL URLWithString:path];
        NSError *error=nil;
        _audioPlayer=[[AVAudioPlayer alloc]initWithContentsOfURL:url error:&error];
        _audioPlayer.numberOfLoops=0;
        _audioPlayer.delegate = self;
        [_audioPlayer prepareToPlay];
    }
    [self.audioPlayer play];
}

- (IBAction)start:(id)sender {
    [self.activityIndicator startAnimating];
    self.stop.enabled = YES;
    self.stop.alpha = 1.0;
    self.start.enabled = NO;
    self.start.alpha = 1.0;
    NSString *time = [self.record getTime];
    self.urlPath = time;
    NSString *urlStr=[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *path = [NSString stringWithFormat:@"%@.caf",time];
    urlStr=[urlStr stringByAppendingPathComponent:path];
    NSURL *url=[NSURL fileURLWithPath:urlStr];
    if (!_audioRecorder) {
        //创建录音格式设置
        NSDictionary *setting=[self getAudioSetting];
        //创建录音机
        NSError *error=nil;
        _audioRecorder=[[AVAudioRecorder alloc]initWithURL:url settings:setting error:&error];
        _audioRecorder.meteringEnabled=YES;//如果要监控声波则必须设置为YES
    }
    if (![self.audioRecorder isRecording]) {
        [self.audioRecorder record];//首次使用应用时如果调用record方法会询问用户是否允许使用麦克风
    }
    if(!_timer1){
        _timer1 = [NSTimer scheduledTimerWithTimeInterval:1.0f target:self selector:@selector(changeTime) userInfo:nil repeats:YES];
    }
}

-(void)changeTime{
    self.sCount++;
    NSString *sStr = [NSString stringWithFormat:@"%02d",self.sCount];
    self.second.text = sStr;
    if (self.sCount == 60) {
        self.mCount++;
        NSString *sStr = [NSString stringWithFormat:@"00"];
        self.second.text = sStr;
        NSString *mStr = [NSString stringWithFormat:@"%02d",self.mCount];
        self.minute.text = mStr;
        self.sCount = 0;
    }
    
    if (self.mCount == 60) {
        NSString *mStr = [NSString stringWithFormat:@"00"];
        self.minute.text = mStr;
        NSString *hStr = [NSString stringWithFormat:@"%02d",self.sCount];
        self.hour.text = hStr;
        self.mCount = 0;
        self.hCount++;
    }
    
    if (self.hCount==99) {
        [self.timer1 invalidate];
    }
}
- (IBAction)stop:(id)sender {
    [self.activityIndicator stopAnimating];
    [self.timer1 invalidate];
    [self.audioRecorder stop];
    self.play.enabled = YES;
    self.play.alpha = 1.0;
    self.done.enabled = YES;
    self.done.alpha = 1.0;
    self.stop.enabled = NO;
    self.stop.alpha = 1.0;
}
- (IBAction)done:(id)sender {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@.caf",[self.record getDoc],self.urlPath];
    NSData *data = [NSData dataWithContentsOfFile:path];
    
    UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"储存录音" message:nil preferredStyle:UIAlertControllerStyleAlert];
    
    [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(alertTextFieldDidChange:) name:UITextFieldTextDidChangeNotification object:textField];
    }];
    
    UIAlertAction *deleteAction = [UIAlertAction actionWithTitle:@"删除" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        UIAlertController *alercontroller = [UIAlertController alertControllerWithTitle:@"确认删除" message:@"确认删除该录音" preferredStyle:UIAlertControllerStyleAlert];
        
        [alercontroller addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [fm removeItemAtPath:path error:nil];
            [self dismissViewControllerAnimated:YES completion:nil];
        }]];
        
        [alercontroller addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self presentViewController:alert animated:YES completion:nil];
        }]];
        
        [self presentViewController:alercontroller animated:YES completion:nil];
    }];
    
    UIAlertAction *saveAction = [UIAlertAction actionWithTitle:@"存储" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        NSArray *textField = alert.textFields;
        UITextField *filename = textField[0];
        [[NSNotificationCenter defaultCenter] removeObserver:self name:UITextFieldTextDidChangeNotification object:nil];
        self.fileName = [NSString stringWithFormat:@"%@.caf",filename.text];
        self.newurlPath = [NSString stringWithFormat:@"%@/%@",[self.record getDoc],self.fileName];
        [fm createFileAtPath:self.newurlPath contents:data attributes:nil];
        [fm removeItemAtPath:path error:nil];
        EditViewController *EVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fifth_id"];
        EVC.voicePath = self.newurlPath;
        EVC.imgPath = self.imgPath;
        EVC.recordFileName = self.fileName;
        EVC.contentText = self.text;
        EVC.imgFileName = self.imgfilename;
        EVC.tagsArr = self.tagsArr;
        EVC.starclickCount = self.isStarred;
        [self.navigationController pushViewController:EVC animated:YES];
    }];
    saveAction.enabled = NO;
    [alert addAction:deleteAction];
    [alert addAction:saveAction];
    [self presentViewController:alert animated:YES completion:nil];
}

- (void)alertTextFieldDidChange:(NSNotification *)notification{
    UIAlertController *alertController = (UIAlertController *)self.presentedViewController;
    if (alertController) {
        UITextField *login = alertController.textFields.firstObject;
        UIAlertAction *saveAction = alertController.actions.lastObject;
        saveAction.enabled = login.text.length > 0;
    }
}

-(void)initButton{
    self.start.enabled = YES;
    self.play.enabled = NO;
    self.play.alpha = 1.0;
    self.stop.enabled = NO;
    self.stop.alpha = 1.0;
    self.done.enabled = NO;
    self.done.alpha = 1.0;
    self.sCount = 0;
    self.mCount = 0;
    self.hCount = 0;
}
-(void)setTimeLabel{
    self.record = [[Record alloc]init];
    NSString *time = [self.record getTime];
    self.timeLabel.text = time;
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:YES];
    self.title = @"Menu";
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initButton];
    [self setAudioSession];
    [self setTimeLabel];
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
