//
//  ViewController.m
//  Voice Journal
//
//  Created by Joe on 16/3/17.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "MainViewController.h"
#import "Memory.h"
#import "RecordViewController.h"
#import "Record.h"
#import "SettingViewController.h"
#import "TimeLineViewController.h"
#import "EditViewController.h"
#import "StarViewController.h"
#import "PhotosViewController.h"
#import "TagsViewController.h"
#import "DiaryViewController.h"
#import "ImgUtil.h"

@interface MainViewController () <UIGestureRecognizerDelegate>
@property (strong, nonatomic) IBOutlet UIImageView *tagIcon;
@property (strong, nonatomic) IBOutlet UIImageView *photoImg;
@property (strong, nonatomic) IBOutlet UILabel *addressLabel;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *recentLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;
@property (strong, nonatomic) IBOutlet UIImageView *starImg;
@property (strong, nonatomic) IBOutlet UIImageView *tagImg;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UILabel *entries;
@property (strong, nonatomic) IBOutlet UILabel *days;
@property (strong, nonatomic) IBOutlet UILabel *weeks;
@property (strong, nonatomic) IBOutlet UILabel *today;
@property (strong, nonatomic) IBOutlet UIProgressView *memory;
@property (nonatomic, strong) Record *record;
@property (nonatomic, strong) CLLocationManager *manager;
@property (nonatomic, strong) CLGeocoder *coder;
@property (nonatomic, strong) NSString *subcitystr;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *fileName;
@property (nonatomic, strong) NSArray *setting;
@property (nonatomic, strong) NSString *bigDocName;
@property (nonatomic, strong) NSString *smallDocName;
@property (nonatomic, strong) NSMutableArray *total;
@property (nonatomic, strong) NSMutableArray *dayscount;
@property (nonatomic, strong) NSMutableArray *todaycount;
@property (nonatomic, strong) NSMutableArray *weekscount;
@property (nonatomic, assign) NSInteger fileCount;
@end

@implementation MainViewController
- (IBAction)addNew:(id)sender {
    EditViewController *EVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fifth_id"];
    [self.navigationController pushViewController:EVC animated:YES];
}
- (IBAction)record:(id)sender {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *recordAction = [UIAlertAction actionWithTitle:@"New Record" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        RecordViewController *RVC = [self.storyboard instantiateViewControllerWithIdentifier:@"second_id"];
        RVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self.navigationController pushViewController:RVC animated:YES];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleDestructive handler:nil];
    [alert addAction:recordAction];
    [alert addAction:cancelAction];
    alert.view.tintColor = [UIColor colorWithRed:169.0/255.0 green:211.0/255.0 blue:230.0/255.0 alpha:1.0];
    [self presentViewController:alert animated:YES completion:nil];
}
- (IBAction)camera:(id)sender {
    self.fileName = [NSString stringWithFormat:@"%@.png",[self.record getTime]];
    self.imagePath = [NSString stringWithFormat:@"%@/%@",[self.record getDoc],self.fileName];
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

}
- (IBAction)timeline:(id)sender {
    TimeLineViewController *TVC = [self.storyboard instantiateViewControllerWithIdentifier:@"forth_id"];
    [self.navigationController pushViewController:TVC animated:YES];
}
- (IBAction)photos:(id)sender {
    PhotosViewController *PVC = [self.storyboard instantiateViewControllerWithIdentifier:@"twelfth_id"];
    [self.navigationController pushViewController:PVC animated:YES];
}
- (IBAction)tags:(id)sender {
    TagsViewController *TVC = [self.storyboard instantiateViewControllerWithIdentifier:@"thirteen_id"];
    [self.navigationController pushViewController:TVC animated:YES];
}
- (IBAction)star:(id)sender {
    StarViewController *STVC = [self.storyboard instantiateViewControllerWithIdentifier:@"seventh_id"];
    [self.navigationController pushViewController:STVC animated:YES];
}
- (IBAction)setting:(id)sender {
    SettingViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"third_id"];
    SVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:SVC animated:YES];
}
-(void)LocalPhoto{
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    [self presentViewController:self.picker animated:YES completion:nil];
}
-(void)getImgWithInfo:(NSDictionary *)info{
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
    }
}
-(void)imagePickerController:(UIImagePickerController*)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    [self dismissViewControllerAnimated:YES completion:^{
        EditViewController *EVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fifth_id"];
        EVC.imgPath = self.imagePath;
        EVC.imgFileName = self.fileName;
        [self.navigationController pushViewController:EVC animated:YES];
    }];
    [self getImgWithInfo:info];
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
- (void)showMemory{
    long long totalMemory = [[Memory totalDiskSpace] longLongValue];
    long long freeMemory = [[Memory freeDiskSpace] longLongValue];
    double usedMemory = (totalMemory - freeMemory)*1.0/totalMemory;
    self.memory.progress = usedMemory;
}
-(void)addGestureRecognizer:(UIView*)tapView {
    //
    NSArray *gestures = tapView.gestureRecognizers;
    for (UIGestureRecognizer *gesture in gestures) {
        [tapView removeGestureRecognizer:gesture];
    }
    //    //新建tap手势
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapView:)];
    //设置点击次数和点击手指数
    tapGesture.delegate = self;
    tapGesture.numberOfTapsRequired = 1; //点击次数
    tapGesture.numberOfTouchesRequired = 1; //点击手指数
    [tapView addGestureRecognizer:tapGesture];
}
-(void)tapView:(UITapGestureRecognizer*) recognizer{
    if (recognizer.view.tag == 9999) {
        if (self.fileCount == 0) {
            UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"错误" message:@"无日志显示" preferredStyle:UIAlertControllerStyleAlert];
            [alert addAction:[UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            }]];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            DiaryViewController *DVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sixth_id"];
            DVC.setting = self.setting;
            DVC.bigDocName = self.bigDocName;
            DVC.smallDocName = self.smallDocName;
            DVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self.navigationController pushViewController:DVC animated:YES];
        }
    }
}

- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations{
    if (locations.count>0) {
        CLLocation *l = [locations lastObject];
        [self.coder reverseGeocodeLocation:l completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
            CLPlacemark *mark = [placemarks lastObject];
            if (!mark.locality) {
                //四大直辖市的城市信息无法通过locality获得，只能通过获取省份的方法来获得（如果city为空，则可知为直辖市）
                self.addressLabel.text = [NSString stringWithFormat:@"%@ %@",mark.administrativeArea,mark.country];
            }
            NSString *addr = [NSString stringWithFormat:@"%@ %@",mark.locality,mark.administrativeArea];
            self.addressLabel.text = addr;
        }];
        
    }
}

-(void)recentWork{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fileList = [fm contentsOfDirectoryAtPath:[self.record getDoc] error:nil];
    NSMutableArray *bigDoc = [[NSMutableArray alloc] init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *path = [[self.record getDoc] stringByAppendingPathComponent:file];
        [fm fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [bigDoc addObject:file];
        }
        isDir = NO;
    }
    NSString *path = [NSString stringWithFormat:@"%@/%@",[self.record getDoc],[bigDoc lastObject]];
    NSArray *smallFileList = [fm contentsOfDirectoryAtPath:path error:nil];
    NSMutableArray *smallDoc = [[NSMutableArray alloc]init];
    for (NSString *file in smallFileList) {
        NSString *docPath = [path stringByAppendingPathComponent:file];
        [fm fileExistsAtPath:docPath isDirectory:(&isDir)];
        if (isDir) {
            [smallDoc addObject:file];
        }
        isDir = NO;
    }
    self.bigDocName = [bigDoc lastObject];
    self.smallDocName = [smallDoc lastObject];
    NSString *filePath = [NSString stringWithFormat:@"%@/%@/%@/setting.txt",[self.record getDoc],self.bigDocName,self.smallDocName];
    self.setting = [[NSArray alloc]initWithContentsOfFile:filePath];
    if (self.setting.count == 0) {
        self.starImg.hidden = YES;
        self.photoImg.hidden = YES;
        self.textView.text = @"无内容";
        self.tagImg.hidden = YES;
        self.titleLabel.hidden = YES;
        self.tagIcon.hidden = YES;
    }else{
        if ([[self.setting objectAtIndex:0] isEqualToString:@" "]) {
            self.photoImg.hidden = YES;
        }else{
            self.photoImg.hidden = NO;
        }
        if ([[self.setting objectAtIndex:2] isEqualToString:@" "]) {
            self.textView.text = @"无内容";
        }else{
            NSString *text = [NSString stringWithContentsOfFile:[self.setting objectAtIndex:2] encoding:NSUTF8StringEncoding error:nil];
            self.textView.text = text;
        }
        if ([[self.setting objectAtIndex:3] isEqualToString:@"0"]) {
            self.starImg.hidden = YES;
        }else{
            self.starImg.hidden = NO;
        }
        if ([[self.setting objectAtIndex:6] isEqualToString:@" "]) {
            self.titleLabel.hidden = YES;
            self.tagImg.hidden = YES;
            self.tagIcon.hidden = YES;
        }else{
            NSString *path = [NSString stringWithFormat:@"%@",[self.setting objectAtIndex:6]];
            NSArray *tags = [[NSArray alloc]initWithContentsOfFile:path];
            if (tags.count == 1) {
                self.tagImg.hidden = NO;
                self.titleLabel.hidden = NO;
                self.tagIcon.hidden = NO;
                self.titleLabel.text = [tags objectAtIndex:0];
            }else{
                self.tagImg.hidden = NO;
                self.titleLabel.hidden = NO;
                self.tagIcon.hidden = NO;
                self.titleLabel.text = [tags objectAtIndex:0];
            }
        }

    }
}
-(void)initGPS{
    //定位管理器
    self.manager = [[CLLocationManager alloc]init];
    self.coder = [[CLGeocoder alloc]init];
    self.manager.distanceFilter = 0.5;
    self.manager.desiredAccuracy = 0.3;
    self.manager.delegate = self;
    [self.manager requestWhenInUseAuthorization];//使用程序其间允许访问位置数据（iOS8定位需要）
    [self.manager startUpdatingLocation];
    self.addressLabel.text = @"－－";

}
-(void)getcount{
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fileList = [fm contentsOfDirectoryAtPath:[self.record getDoc] error:nil];
    self.fileCount = fileList.count;
    NSMutableArray *bigDoc = [[NSMutableArray alloc] init];
    self.total = [[NSMutableArray alloc]init];
    self.dayscount = [[NSMutableArray alloc]init];
    self.todaycount = [[NSMutableArray alloc]init];
    self.weekscount = [[NSMutableArray alloc]init];
    BOOL isDir = NO;
    //在上面那段程序中获得的fileList中列出文件夹名
    for (NSString *file in fileList) {
        NSString *path = [[self.record getDoc] stringByAppendingPathComponent:file];
        [fm fileExistsAtPath:path isDirectory:(&isDir)];
        if (isDir) {
            [bigDoc addObject:file];
        }
        isDir = NO;
    }
    for (NSString *bigdoc in bigDoc) {
        NSArray *fileList1 = [fm contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@",[self.record getDoc],bigdoc] error:nil];
        NSMutableArray *smallDoc = [[NSMutableArray alloc] init];
        BOOL isDir1 = NO;
        //在上面那段程序中获得的fileList中列出文件夹名
        for (NSString *file in fileList1) {
            NSString *path1 = [[NSString stringWithFormat:@"%@/%@",[self.record getDoc],bigdoc] stringByAppendingPathComponent:file];
            [fm fileExistsAtPath:path1 isDirectory:(&isDir1)];
            if (isDir1) {
                [smallDoc addObject:file];
            }
            isDir1 = NO;
        }
        for (NSString *smalldoc in smallDoc) {
            int havedays = 0;
            [self.total addObject:smalldoc];
            NSString *path2 = [NSString stringWithFormat:@"%@/%@/%@/setting.txt",[self.record getDoc],bigdoc,smalldoc];
            NSArray *setting = [[NSArray alloc]initWithContentsOfFile:path2];
            for (NSString *str in self.dayscount) {
                NSLog(@"%@", str);
                if ([str isEqualToString:[setting objectAtIndex:4]]) {
                    havedays = 1;
                }
            }
            if (havedays == 0) {
                [self.dayscount addObject:[setting objectAtIndex:4]];
            }
            if ([[self getTime] isEqualToString:[setting objectAtIndex:4]]) {
                [self.todaycount addObject:smalldoc];
            }
            if ([self getWeek:[self getTime]] == [self getWeek:[setting objectAtIndex:4]]) {
                [self.weekscount addObject:smalldoc];
            }
        }
    }
    self.entries.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.total.count];
    self.today.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.todaycount.count];
    self.days.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.dayscount.count];
    self.weeks.text = [NSString stringWithFormat:@"%lu",(unsigned long)self.weekscount.count];
}
- (NSString *)getTime{
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    //设置时间输出格式：
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy年 MM月 dd日"];
    NSString * na = [df stringFromDate:currentDate];
    return na;
}
-(NSInteger)getWeek:(NSString *)time{
    NSCalendar*calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *comps;
    NSString *string = time;
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy年 MM月 dd日"];
    NSDate *inputDate = [inputFormatter dateFromString:string];
    comps =[calendar components:(NSWeekCalendarUnit | NSWeekdayCalendarUnit |NSWeekdayOrdinalCalendarUnit)
            
                       fromDate:inputDate];
    NSInteger week = [comps weekOfMonth];
    return week;
}
-(void)initUI{
    [self addGestureRecognizer:self.textView];
    self.titleLabel.hidden = YES;
    self.tagImg.hidden = YES;
    self.tagIcon.hidden = YES;
    [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    self.picker  = [[UIImagePickerController alloc]init];
    self.addressLabel.adjustsFontSizeToFitWidth = YES;
    self.recentLabel.adjustsFontSizeToFitWidth = YES;
    self.textLabel.adjustsFontSizeToFitWidth = YES;
    self.titleLabel.adjustsFontSizeToFitWidth = YES;
    self.days.adjustsFontSizeToFitWidth = YES;
    self.weeks.adjustsFontSizeToFitWidth = YES;
    self.entries.adjustsFontSizeToFitWidth = YES;
    self.today.adjustsFontSizeToFitWidth = YES;
    CGSize size = CGSizeMake(320.0f, 600.0f);
    [self.textView setContentSize:size];
    self.textView.scrollEnabled = NO;
    self.starImg.hidden = YES;
    self.photoImg.hidden = YES;
    self.weeks.text = @"0";
}
-(void)viewWillAppear:(BOOL)animated{
    [self recentWork];
    [self getcount];
    [self showMemory];
    [self.navigationController.navigationBar setHidden:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    [self initGPS];
    self.record = [[Record alloc]init];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
