//
//  StarViewController.m
//  Voice Journal
//
//  Created by Joe on 16/4/23.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "StarViewController.h"
#import "EditViewController.h"
#import "MainViewController.h"
#import "Record.h"
#import "DiaryViewController.h"

@interface StarViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) IBOutlet UITableViewCell *textCell;
@property (strong, nonatomic) Record *record;
@property (strong, nonatomic) NSMutableDictionary *dataSource;
@property (strong, nonatomic) NSString *subtime;
@property (strong, nonatomic) NSString *day;
@end

@implementation StarViewController

- (void)add {
    EditViewController *EVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fifth_id"];
    [self.navigationController pushViewController:EVC animated:YES];
}
-(void)initUI{
    self.record = [[Record alloc]init];
    self.tableView.rowHeight = 120;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getSectionAndRow];
}
-(void)getSectionAndRow{
    self.dataSource = [[NSMutableDictionary alloc]init];
    NSFileManager *fm = [NSFileManager defaultManager];
    NSArray *fileList = [fm contentsOfDirectoryAtPath:[self.record getDoc] error:nil];
    NSMutableArray *bigDoc = [[NSMutableArray alloc] init];
    NSMutableDictionary *datasource = [[NSMutableDictionary alloc]init];
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
        NSMutableArray *row = [NSMutableArray arrayWithCapacity:5];
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
            NSString *path2 = [NSString stringWithFormat:@"%@/%@/%@/setting.txt",[self.record getDoc],bigdoc,smalldoc];
            NSArray *setting = [[NSArray alloc]initWithContentsOfFile:path2];
            if ([[setting objectAtIndex:3] isEqualToString:@"1"]) {
                [row addObject:smalldoc];
                [datasource setObject:row forKey:bigdoc];
            }
        }
    }
    self.dataSource = datasource;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    // Do any additional setup after loading the view.
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    NSArray *key = [self.dataSource allKeys];
    return key.count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSArray *key = [self.dataSource allKeys];
    NSArray *value = [self.dataSource objectForKey:[key objectAtIndex:section]];
    return value.count;
}
-(NSArray *)getSettingWithIndexPath:(NSIndexPath *)indexPath{
    NSArray *key = [self.dataSource allKeys];
    NSString *bigDocName = [key objectAtIndex:indexPath.section];
    NSArray *value = [self.dataSource objectForKey:bigDocName];
    NSString *smallDocName = [value objectAtIndex:indexPath.row];
    NSString *time = [smallDocName substringFromIndex:6];
    self.subtime = [time substringToIndex:6];
    NSRange range = NSMakeRange(0,2);
    self.day = [smallDocName substringWithRange:range];
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@/setting.txt",[self.record getDoc],bigDocName,smallDocName];
    NSArray *setting = [[NSArray alloc]initWithContentsOfFile:path];
    return setting;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSArray *setting = [self getSettingWithIndexPath:indexPath];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cid"];
    NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"TextView" owner:self options:nil];
    if (nib.count > 0) {
        self.textCell = [nib objectAtIndex:0];
        cell = self.textCell;
    }
    UILabel *timeLabel = (UILabel *)[cell.contentView viewWithTag:2];
    UITextView *textView = (UITextView *)[cell.contentView viewWithTag:1];
    UILabel *dayLabel = (UILabel *)[cell.contentView viewWithTag:8];
    UIImageView *photo = (UIImageView *)[cell.contentView viewWithTag:4];
    UIImageView *record = (UIImageView *)[cell.contentView viewWithTag:5];
    UIImageView *star = (UIImageView *)[cell.contentView viewWithTag:6];
    UILabel *tag = (UILabel *)[cell.contentView viewWithTag:7];
    UIImageView *img = (UIImageView *)[cell.contentView viewWithTag:9];
    UILabel *moretag = (UILabel *)[cell.contentView viewWithTag:10];
    UIImageView *img1 = (UIImageView *)[cell.contentView viewWithTag:11];
    UIImageView *img2 = (UIImageView *)[cell.contentView viewWithTag:12];
    if ([[setting objectAtIndex:0] isEqualToString:@" "]) {
        img.hidden = YES;
        photo.hidden = YES;
    }else{
        NSData *data = [NSData dataWithContentsOfFile:[setting objectAtIndex:0]];
        img.image = [UIImage imageWithData:data];
    }
    if ([[setting objectAtIndex:1] isEqualToString:@" "]) {
        record.hidden = YES;
    }
    if ([[setting objectAtIndex:2] isEqualToString:@" "]) {
        textView.text = @"无内容";
    }else{
        NSString *text = [NSString stringWithContentsOfFile:[setting objectAtIndex:2] encoding:NSUTF8StringEncoding error:nil];
        if (text.length > 45) {
            NSString *subtext = [NSString stringWithFormat:@"%@...",[text substringToIndex:42]];
            textView.text = subtext;
        }else{
            textView.text = text;
        }
    }
    if ([[setting objectAtIndex:3] isEqualToString:@"0"]) {
        star.hidden = YES;
    }
    if ([[setting objectAtIndex:6] isEqualToString:@" "]) {
        img1.hidden = YES;
        img2.hidden = YES;
        tag.hidden = YES;
        moretag.hidden = YES;
    }else{
        NSString *path = [NSString stringWithFormat:@"%@",[setting objectAtIndex:6]];
        NSArray *tags = [[NSArray alloc]initWithContentsOfFile:path];
        if (tags.count == 1) {
            img1.hidden = YES;
            moretag.hidden = YES;
            tag.text = [tags objectAtIndex:0];
        }else{
            tag.text = [tags objectAtIndex:0];
        }
    }
    dayLabel.text = self.day;
    textView.editable = NO;
    timeLabel.text = self.subtime;
    return cell;
    return nil;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    //这个方法用来告诉表格第section分组的名称
    NSArray *keys = [self.dataSource allKeys];
    NSString *key = [keys objectAtIndex:section];
    UIView *customView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 20)];
    customView.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    UILabel * headerLabel = [[UILabel alloc] initWithFrame:CGRectMake(150, 5, 100, 20)];
    headerLabel.backgroundColor = [UIColor colorWithRed:248.0/255.0 green:248.0/255.0 blue:248.0/255.0 alpha:1.0];
    headerLabel.text = key;
    headerLabel.textAlignment = NSTextAlignmentCenter;
    headerLabel.textColor = [UIColor colorWithRed:143.0/255.0 green:142.0/255.0 blue:148.0/255.0 alpha:1.0];
    headerLabel.font = [UIFont fontWithName:@"Arial-bold" size:13];
    [customView addSubview:headerLabel];
    
    return customView;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *key = [self.dataSource allKeys];
    NSString *bigDocName = [key objectAtIndex:indexPath.section];
    NSArray *value = [self.dataSource objectForKey:bigDocName];
    NSString *smallDocName = [value objectAtIndex:indexPath.row];
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@/setting.txt",[self.record getDoc],bigDocName,smallDocName];
    NSArray *setting = [[NSArray alloc]initWithContentsOfFile:path];
    DiaryViewController *DVC = [self.storyboard instantiateViewControllerWithIdentifier:@"sixth_id"];
    DVC.setting = setting;
    DVC.bigDocName = bigDocName;
    DVC.smallDocName = smallDocName;
    [self.navigationController pushViewController:DVC animated:YES];
}
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}
- (NSString *)tableView:(UITableView *)tableView titleForDeleteConfirmationButtonForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return @"删除";
}
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *keys = [self.dataSource allKeys];
    NSMutableArray *values = [self.dataSource objectForKey:[keys objectAtIndex:indexPath.section]];
    //删除沙盒文件
    NSFileManager *fm = [NSFileManager defaultManager];
    NSString *path = [NSString stringWithFormat:@"%@/%@/%@",[self.record getDoc],[keys objectAtIndex:indexPath.section],[values objectAtIndex:indexPath.row]];
    NSString *bigDirPath = [NSString stringWithFormat:@"%@/%@",[self.record getDoc],[keys objectAtIndex:indexPath.section]];
    NSArray *fileList = [fm contentsOfDirectoryAtPath:path error:nil];
    for (NSString *file in fileList) {
        NSString *filePath = [NSString stringWithFormat:@"%@/%@",path,file];
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
    //删除数据源
    [values removeObjectAtIndex:indexPath.row];
    // 从列表中删除
    [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav Bar"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.title = @"Star";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0f], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];
    
    UIButton *addEdit = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 46, 20)];
    [addEdit setImage:[UIImage imageNamed:@"Top Add Icon"] forState:UIControlStateNormal];
    [addEdit addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn1=[[UIBarButtonItem alloc]initWithCustomView:addEdit];
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
