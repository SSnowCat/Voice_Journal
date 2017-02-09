//
//  SettingViewController.m
//  Voice Journal
//
//  Created by Joe on 16/4/12.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "SettingViewController.h"
#import "NewPassCodeViewController.h"
#import "MainViewController.h"
#import "OldPasscodeViewController.h"
#import "SwitchTableViewCell.h"
#import "NoSwitchTableViewCell.h"
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
@interface SettingViewController ()
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSDictionary *dataSource;
@end

@implementation SettingViewController

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    //这个方法用来告诉表格有几个分组
    return [self.dataSource allKeys].count;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = [[self.dataSource allKeys] objectAtIndex:section];
    NSArray *cities = [self.dataSource objectForKey:key];
    return cities.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NSUserDefaults *userDefault = [NSUserDefaults standardUserDefaults];
    NSUInteger section = [indexPath section];
    NSUInteger row = [indexPath row];
    NSArray *keys = [self.dataSource allKeys];
    NSString *key = [keys objectAtIndex:section];
    NSArray *values = [self.dataSource objectForKey:key];
    if (indexPath.row == 0) {
        SwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"SwitchTableViewCell"];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.cellName.text = [values objectAtIndex:row];
        [cell.select addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
        cell.select.tag = indexPath.section*10 + indexPath.row;
        if ([[values objectAtIndex:row] isEqualToString:@"Passcode"]) {
            cell.select.on = [userDefault boolForKey:@"password"];
        }
        if ([[values objectAtIndex:row] isEqualToString:@"Touch ID"]) {
            cell.select.on = [userDefault boolForKey:@"touchID"];
        }
        return cell;
    }else{
        NoSwitchTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"NoSwitchTableViewCell"];
        cell.cellName.text = [values objectAtIndex:row];
        return cell;
    }
}
-(void)switchAction:(UISwitch *)sender{
    NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
    if (sender.tag == 00 && sender.on == YES) {
        [userDefauts setBool:YES forKey:@"password"];
        if ([userDefauts objectForKey:@"passcode"] == nil) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"创建密码" message:@"是否需要创建密码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                sender.on = NO;
                [userDefauts setBool:NO forKey:@"password"];
            }];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                NewPassCodeViewController *NPCVC = [self.storyboard instantiateViewControllerWithIdentifier:@"nineth_id"];
                [self.navigationController pushViewController:NPCVC animated:YES];
            }];
            [alert addAction:cancel];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
        }
    }
    if (sender.tag == 00 && sender.on == NO) {
        [userDefauts setBool:NO forKey:@"password"];
        [userDefauts setBool:NO forKey:@"touchID"];
        [self.tableView reloadData];

    }
    if (sender.tag == 10 && sender.on == YES) {
        if ([userDefauts objectForKey:@"passcode"] == nil||[userDefauts boolForKey:@"password"] == NO) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"开启错误" message:@"您未创建密码或未开启密码验证" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                sender.on = NO;
            }];
            [alert addAction:cancel];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            [userDefauts setBool:YES forKey:@"touchID"];
        }
    }
    if (sender.tag == 10 && sender.on == NO) {
        [userDefauts setBool:NO forKey:@"touchID"];
    }
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *str = [NSString stringWithFormat:@"%ld/%ld",(long)indexPath.section,(long)indexPath.row];
    NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
    if ([str isEqualToString:@"0/1"]) {
        NSLog(@"%@",str);
        NSLog(@"%@",[userDefauts objectForKey:@"passcode"]);
        if ([userDefauts objectForKey:@"passcode"] == nil) {
            UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"创建密码" message:@"是否先创建密码" preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                nil;
            }];
            UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                [userDefauts setBool:YES forKey:@"password"];
                NewPassCodeViewController *NPCVC = [self.storyboard instantiateViewControllerWithIdentifier:@"nineth_id"];
                [self.navigationController pushViewController:NPCVC animated:YES];
            }];
            [alert addAction:cancel];
            [alert addAction:confirm];
            [self presentViewController:alert animated:YES completion:nil];
        }else{
            if ([userDefauts boolForKey:@"password"] == NO){
                UIAlertController *alert=[UIAlertController alertControllerWithTitle:@"打开密码" message:@"请确认是否打开密码验证" preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *confirm = [UIAlertAction actionWithTitle:@"确认" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    nil;
                }];
                [alert addAction:confirm];
                [self presentViewController:alert animated:YES completion:nil];
            }else{
                OldPasscodeViewController *OPVC = [self.storyboard instantiateViewControllerWithIdentifier:@"eleventh_id"];
                [self.navigationController pushViewController:OPVC animated:YES];
            }
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.dataSource = @{@"  ":@[@"Touch ID"],@" ":@[@"Passcode",@"Change Passcode"]};
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerNib:[UINib nibWithNibName:@"SwitchTableViewCell" bundle:nil] forCellReuseIdentifier:@"SwitchTableViewCell"];
    [self.tableView registerNib:[UINib nibWithNibName:@"NoSwitchTableViewCell" bundle:nil] forCellReuseIdentifier:@"NoSwitchTableViewCell"];
    //self.tableView.table
    // Do any additional setup after loading the view.
}
-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController.navigationBar setHidden:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"Nav Bar"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
    self.title = @"Setting";
    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:17.0f],NSFontAttributeName,[UIColor whiteColor],NSForegroundColorAttributeName,nil]];
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
