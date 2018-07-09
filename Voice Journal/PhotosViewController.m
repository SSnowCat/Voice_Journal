//
//  PhotosViewController.m
//  Voice Journal
//
//  Created by Joe on 16/4/27.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "PhotosViewController.h"
#import "DiaryViewController.h"
#import "EditViewController.h"
#import "ImgUtil.h"
#import "MyCollectionViewCell.h"
#import "Record.h"
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)   //屏幕物理宽度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) //屏幕物理高度

@interface PhotosViewController ()
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSMutableDictionary *dataSource;
@property (strong, nonatomic) Record *record;
@property (strong, nonatomic) NSString *subtime;
@property (strong, nonatomic) NSString *day;
@property (strong, nonatomic) UIImagePickerController *picker;
@property (nonatomic, strong) NSString *imagePath;
@property (nonatomic, strong) NSString *fileName;
@end

static NSString *cid = @"cid";

@implementation PhotosViewController
- (void)camera {
    self.fileName = [NSString stringWithFormat:@"%@.png", [self.record getTime]];
    self.imagePath = [NSString stringWithFormat:@"%@/%@", [self.record getDoc], self.fileName];
    UIAlertController *alert =
      [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];

    [alert addAction:[UIAlertAction actionWithTitle:@"Take Photo"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                // 设置照片来源为相机
                                                self.picker.sourceType = UIImagePickerControllerSourceTypeCamera;

                                                // 设置进入相机时使用前置或后置摄像头
                                                self.picker.cameraDevice = UIImagePickerControllerCameraDeviceRear;
                                                self.picker.delegate = self;
                                                self.picker.allowsEditing = YES;
                                                // 展示选取照片控制器
                                                [self presentViewController:self.picker
                                                                   animated:YES
                                                                 completion:^{
                                                                 }];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Choose from Library"
                                              style:UIAlertActionStyleDefault
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                [self LocalPhoto];
                                            }]];
    [alert addAction:[UIAlertAction actionWithTitle:@"Cancel"
                                              style:UIAlertActionStyleDestructive
                                            handler:^(UIAlertAction *_Nonnull action) {
                                                nil;
                                            }]];
    alert.view.tintColor = [UIColor blackColor];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)getSectionAndRow {
    self.dataSource = [[NSMutableDictionary alloc] init];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fileList = [fm contentsOfDirectoryAtPath:[self.record getDoc] error:nil];
    NSMutableArray *bigDoc = [[NSMutableArray alloc] init];
    NSMutableDictionary *datasource = [[NSMutableDictionary alloc] init];
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
        NSMutableArray *row = [[NSMutableArray alloc] init];
        NSArray *fileList1 =
          [fm contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", [self.record getDoc], bigdoc] error:nil];
        NSMutableArray *smallDoc = [[NSMutableArray alloc] init];
        BOOL isDir1 = NO;
        //在上面那段程序中获得的fileList中列出文件夹名
        for (NSString *file in fileList1) {
            NSString *path1 =
              [[NSString stringWithFormat:@"%@/%@", [self.record getDoc], bigdoc] stringByAppendingPathComponent:file];
            [fm fileExistsAtPath:path1 isDirectory:(&isDir1)];
            if (isDir1) {
                [smallDoc addObject:file];
            }
            isDir1 = NO;
        }
        for (NSString *smalldoc in smallDoc) {
            NSString *path2 =
              [NSString stringWithFormat:@"%@/%@/%@/setting.txt", [self.record getDoc], bigdoc, smalldoc];
            NSArray *setting = [[NSArray alloc] initWithContentsOfFile:path2];
            if (![[setting objectAtIndex:0] isEqualToString:@" "]) {
                [row addObject:smalldoc];
                [datasource setObject:row forKey:bigdoc];
            }
        }
    }
    NSLog(@"%@", datasource);
    self.dataSource = datasource;
}
- (void)initUI {
    self.picker = [[UIImagePickerController alloc] init];
    self.record = [[Record alloc] init];
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"HeaderView"];

    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 30);
    [self.collectionView setCollectionViewLayout:flowLayout];
    [self.collectionView registerClass:[UICollectionReusableView class]
            forSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                   withReuseIdentifier:@"header"];
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:cid];
    [self getSectionAndRow];
    UILongPressGestureRecognizer *longPress =
      [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(myHandleTableviewCellLongPressed:)];
    longPress.minimumPressDuration = 1.0;
    //将长按手势添加到需要实现长按操作的视图里
    [self.collectionView addGestureRecognizer:longPress];
}
- (void)myHandleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer {

    CGPoint pointTouch = [gestureRecognizer locationInView:self.collectionView];

    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:pointTouch];
        NSArray *keys = [self.dataSource allKeys];
        NSMutableArray *values = [self.dataSource objectForKey:[keys objectAtIndex:indexPath.section]];
        //删除沙盒文件
        NSFileManager *fm = [NSFileManager defaultManager];
        NSString *path = [NSString stringWithFormat:@"%@/%@/%@", [self.record getDoc],
                                   [keys objectAtIndex:indexPath.section], [values objectAtIndex:indexPath.row]];
        NSString *bigDirPath =
          [NSString stringWithFormat:@"%@/%@", [self.record getDoc], [keys objectAtIndex:indexPath.section]];
        NSArray *fileList = [fm contentsOfDirectoryAtPath:path error:nil];
        for (NSString *file in fileList) {
            NSString *filePath = [NSString stringWithFormat:@"%@/%@", path, file];
            [fm removeItemAtPath:filePath error:nil];
        }
        NSArray *newfileList = [fm contentsOfDirectoryAtPath:path error:nil];
        if (newfileList.count == 0) {
            [fm removeItemAtPath:path error:nil];
        }
        NSArray *newbigFileList = [fm contentsOfDirectoryAtPath:bigDirPath error:nil];
        if (newbigFileList.count == 0) {
            [fm removeItemAtPath:bigDirPath error:nil];
        }
        [values removeObjectAtIndex:indexPath.row];
        [self.collectionView deleteItemsAtIndexPaths:@[indexPath]];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}
- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *keys = [self.dataSource allKeys];
    NSArray *values = [self.dataSource objectForKey:[keys objectAtIndex:indexPath.section]];
    if (values.count % 2 != 0) {
        if (indexPath.row == values.count - 1) {
            return CGSizeMake(SCREEN_WIDTH, 200);
        } else {
            return CGSizeMake(SCREEN_WIDTH / 2, 200);
        }
    } else {
        return CGSizeMake(SCREEN_WIDTH / 2, 200);
    }
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                               layout:(UICollectionViewLayout *)collectionViewLayout
  minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView
                                    layout:(UICollectionViewLayout *)collectionViewLayout
  minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 0.0;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSArray *keys = [self.dataSource allKeys];
    NSArray *values = [self.dataSource objectForKey:[keys objectAtIndex:section]];
    return values.count;
    ;
}
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    NSArray *keys = [self.dataSource allKeys];
    return keys.count;
}
- (NSArray *)getSettingWithIndexPath:(NSIndexPath *)indexPath {
    NSArray *key = [self.dataSource allKeys];
    NSString *bigDocName = [key objectAtIndex:indexPath.section];
    NSArray *value = [self.dataSource objectForKey:bigDocName];
    NSString *smallDocName = [value objectAtIndex:indexPath.row];
    NSString *time = [smallDocName substringFromIndex:6];
    self.subtime = [time substringToIndex:6];
    NSRange range = NSMakeRange(0, 2);
    self.day = [smallDocName substringWithRange:range];
    NSString *path =
      [NSString stringWithFormat:@"%@/%@/%@/setting.txt", [self.record getDoc], bigDocName, smallDocName];
    NSArray *setting = [[NSArray alloc] initWithContentsOfFile:path];
    return setting;
}
- (NSString *)getWeek:(NSString *)date {
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
    [inputFormatter setDateFormat:@"yyyy年 MM月 dd日"];
    NSDate *inputDate = [inputFormatter dateFromString:date];
    NSDateFormatter *outputFormatter = [[NSDateFormatter alloc] init];
    [outputFormatter setLocale:[NSLocale currentLocale]];
    [outputFormatter setDateFormat:@"EEEE"];
    NSString *week = [outputFormatter stringFromDate:inputDate];
    return week;
}
- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView
                  cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *setting = [self getSettingWithIndexPath:indexPath];
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cid forIndexPath:indexPath];
    NSData *data = [NSData dataWithContentsOfFile:[setting objectAtIndex:0]];
    cell.img.image = [UIImage imageWithData:data];
    cell.yearLabel.text = [setting objectAtIndex:4];
    cell.dayLabel.text = self.day;
    cell.timeLabel.text = self.subtime;
    cell.weekLabel.text = [self getWeek:[setting objectAtIndex:4]];
    return cell;
}
- (void)LocalPhoto {
    self.picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    self.picker.delegate = self;
    self.picker.allowsEditing = YES;
    [self presentViewController:self.picker animated:YES completion:nil];
}
- (void)getImgWithInfo:(NSDictionary *)info {
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *type = [info objectForKey:UIImagePickerControllerMediaType];
    //当选择的类型是图片
    if ([type isEqualToString:@"public.image"]) {
        //先把图片转成NSData
        UIImage *imageOriginal = [info objectForKey:UIImagePickerControllerOriginalImage];
        UIImage *image = [ImgUtil fixOrientation:imageOriginal];
        if (self.picker.sourceType == UIImagePickerControllerSourceTypeCamera) {
            UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        NSData *data;
        if (UIImagePNGRepresentation(image) == nil) {
            data = UIImageJPEGRepresentation(image, 1.0);
        } else {
            data = UIImagePNGRepresentation(image);
        }
        [fm createFileAtPath:self.imagePath contents:data attributes:nil];
    }
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    //关闭相册界面
    [picker dismissViewControllerAnimated:YES
                               completion:^{
                                   EditViewController *EVC =
                                     [self.storyboard instantiateViewControllerWithIdentifier:@"fifth_id"];
                                   EVC.imgPath = self.imagePath;
                                   EVC.imgFileName = self.fileName;
                                   [self.navigationController pushViewController:EVC animated:YES];
                               }];
    [self getImgWithInfo:info];
}
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        nil;
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}
- (UICollectionViewFlowLayout *)flowLayout {
    UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc] init];
    flowLayout.headerReferenceSize = CGSizeMake(SCREEN_WIDTH, 20.0f); //设置head大小
    return flowLayout;
}
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView
           viewForSupplementaryElementOfKind:(NSString *)kind
                                 atIndexPath:(NSIndexPath *)indexPath {
    NSArray *keys = [self.dataSource allKeys];
    NSString *key = [keys objectAtIndex:indexPath.section];
    UICollectionReusableView *reusableview = nil;
    if (kind == UICollectionElementKindSectionHeader) {
        UICollectionReusableView *headerView =
          [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader
                                             withReuseIdentifier:@"HeaderView"
                                                    forIndexPath:indexPath];
        reusableview = headerView;
    }
    reusableview.backgroundColor = [UIColor blackColor];
    UILabel *headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(SCREEN_WIDTH / 2 - 50, 5, 100, 20)];
    headerLabel.backgroundColor = [UIColor blackColor];
    headerLabel.text = key;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor colorWithRed:143.0 / 255.0 green:142.0 / 255.0 blue:148.0 / 255.0 alpha:1.0];
    headerLabel.font = [UIFont fontWithName:@"Arial-bold" size:13];
    [reusableview addSubview:headerLabel];
    return reusableview;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
    NSArray *key = [self.dataSource allKeys];
    NSString *bigDocName = [key objectAtIndex:indexPath.section];
    NSArray *value = [self.dataSource objectForKey:bigDocName];
    NSString *smallDocName = [value objectAtIndex:indexPath.row];
    NSString *path =
      [NSString stringWithFormat:@"%@/%@/%@/setting.txt", [self.record getDoc], bigDocName, smallDocName];
    NSArray *setting = [[NSArray alloc] initWithContentsOfFile:path];
    DiaryViewController *DVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sixth_id"];
    DVC.setting = setting;
    DVC.bigDocName = bigDocName;
    DVC.smallDocName = smallDocName;
    DVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self.navigationController pushViewController:DVC animated:YES];
}
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav Bar"]
                                                  forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.title = @"Photos";
    [self.navigationController.navigationBar
      setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0f],
                                           NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName,
                                           nil]];

    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 30)];
    [doneBtn setImage:[UIImage imageNamed:@"Camera"] forState:UIControlStateNormal];
    [doneBtn addTarget:self action:@selector(camera) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn1 = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    self.navigationItem.rightBarButtonItem = barBtn1;
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
