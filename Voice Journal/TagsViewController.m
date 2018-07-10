//
//  TagsViewController.m
//  Voice Journal
//
//  Created by Joe on 16/4/28.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "TagsViewController.h"
#import "EditViewController.h"
#import "Record.h"
#import "SecondTagsViewController.h"

@interface TagsViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) Record *              record;
@property (strong, nonatomic) NSArray *             dataSource;
@property (assign, nonatomic) int                   haveTag;
@end

@implementation TagsViewController
- (void)add {
    EditViewController *EVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fifth_id"];
    [self.navigationController pushViewController:EVC animated:YES];
}
- (void)initUI {
    self.record = [[Record alloc] init];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self getSectionAndRow];
}
- (void)getSectionAndRow {
    self.dataSource = [[NSArray alloc] init];
    NSMutableArray *row = [NSMutableArray arrayWithCapacity:5];
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
    for (NSString *bigdoc in bigDoc) {
        NSArray *fileList1 = [fm contentsOfDirectoryAtPath:[NSString stringWithFormat:@"%@/%@", [self.record getDoc], bigdoc] error:nil];
        NSMutableArray *smallDoc = [[NSMutableArray alloc] init];
        BOOL isDir1 = NO;
        //在上面那段程序中获得的fileList中列出文件夹名
        for (NSString *file in fileList1) {
            NSString *path1 = [[NSString stringWithFormat:@"%@/%@", [self.record getDoc], bigdoc] stringByAppendingPathComponent:file];
            [fm fileExistsAtPath:path1 isDirectory:(&isDir1)];
            if (isDir1) {
                [smallDoc addObject:file];
            }
            isDir1 = NO;
        }
        for (NSString *smalldoc in smallDoc) {
            NSString *path2 = [NSString stringWithFormat:@"%@/%@/%@/setting.txt", [self.record getDoc], bigdoc, smalldoc];
            NSArray *setting = [[NSArray alloc] initWithContentsOfFile:path2];
            NSLog(@"%@", [setting objectAtIndex:6]);
            if (![[setting objectAtIndex:6] isEqualToString:@" "]) {
                NSString *path2 = [NSString stringWithFormat:@"%@/%@/%@/tags.txt", [self.record getDoc], bigdoc, smalldoc];
                NSMutableArray *tags = [NSMutableArray arrayWithContentsOfFile:path2];
                for (NSString *tag in tags) {
                    self.haveTag = 0;
                    for (NSString *str in row) {
                        if ([tag isEqualToString:str]) {
                            self.haveTag = 1;
                        }
                    }
                    if (self.haveTag == 0) {
                        [row addObject:tag];
                    }
                }
            }
        }
    }
    self.dataSource = [row sortedArrayUsingSelector:@selector(compare:)];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.dataSource.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cid"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cid"];
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.font = [UIFont fontWithName:@"Arial-bold" size:13];
    cell.textLabel.textColor = [UIColor grayColor];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    SecondTagsViewController *STVC = [self.storyboard instantiateViewControllerWithIdentifier:@"fourteen_id"];
    STVC.tag = [self.dataSource objectAtIndex:indexPath.row];
    [self.navigationController pushViewController:STVC animated:YES];
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav Bar"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.title = @"Tags";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0f], NSFontAttributeName, [UIColor whiteColor], NSForegroundColorAttributeName, nil]];

    UIButton *addEdit = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 46, 20)];
    [addEdit setImage:[UIImage imageNamed:@"Top Add Icon"] forState:UIControlStateNormal];
    [addEdit addTarget:self action:@selector(add) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn1 = [[UIBarButtonItem alloc] initWithCustomView:addEdit];
    self.navigationItem.rightBarButtonItem = barBtn1;
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
