//
//  PassCodeViewController.m
//  Voice Journal
//
//  Created by Joe on 16/4/24.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "PassCodeViewController.h"
#import "ViewController.h"

@interface PassCodeViewController ()
@property (strong, nonatomic) IBOutlet UITextField *passCode;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UIImageView *img3;
@property (strong, nonatomic) IBOutlet UIImageView *img4;
@property (strong, nonatomic) IBOutlet UILabel *warnLabel;

@end

@implementation PassCodeViewController
- (void)authenticateUser{
    //初始化上下文对象
    LAContext* context = [[LAContext alloc] init];
    //错误对象
    NSError* error = nil;
    NSString* result = @"验证指纹解锁";
    //首先使用canEvaluatePolicy 判断设备支持状态
    if ([context canEvaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics error:&error]) {
        //支持指纹验证
        [context evaluatePolicy:LAPolicyDeviceOwnerAuthenticationWithBiometrics localizedReason:result reply:^(BOOL success, NSError *error) {
            if (success) {
                //验证成功，主线程处理UI
                dispatch_sync(dispatch_get_main_queue(), ^{
                    ViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"first_id"];
                    [self presentViewController:VC animated:YES completion:nil];
                });
            }
        }];
    }
}
-(void)setUI{
    NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
    if ([userDefauts boolForKey:@"touchID"] == YES) {
        [self authenticateUser];
    }
    self.view.backgroundColor = [UIColor colorWithRed:144.0/255.0 green:200.0/255.0 blue:194.0/255.0 alpha:1.0];
    self.img1.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
    self.img2.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
    self.img3.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
    self.img4.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
    self.passCode.hidden = YES;
    self.passCode.keyboardType = UIKeyboardTypeNumberPad;
    [self.passCode addTarget:self action:@selector(txchange:) forControlEvents:UIControlEventEditingChanged];
    
    //进入界面，topTX成为第一响应
    [self.passCode becomeFirstResponder];
}
- (void)txchange:(UITextField *)tx
{
    NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
    NSString *password = tx.text;
    if (password.length == 0) {
        self.img1.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
        self.img2.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
        self.img3.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
        self.img4.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
    }
    if (password.length == 1) {
        self.img1.image = [UIImage imageNamed:@"Oval 133 Copy@2x.png"];
        self.img2.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
        self.img3.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
        self.img4.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
    }
    if (password.length == 2) {
        self.img2.image = [UIImage imageNamed:@"Oval 133 Copy@2x.png"];
        self.img3.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
        self.img4.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
    }
    if (password.length == 3) {
        self.img3.image = [UIImage imageNamed:@"Oval 133 Copy@2x.png"];
        self.img4.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
    }
    if (password.length == 4)
    {
        self.img4.image = [UIImage imageNamed:@"Oval 133 Copy@2x.png"];
        if ([password isEqualToString:[userDefauts objectForKey:@"passcode"]]) {
            [tx resignFirstResponder];
            ViewController *VC = [self.storyboard instantiateViewControllerWithIdentifier:@"first_id"];
            [self presentViewController:VC animated:YES completion:nil];
        }else{
            [tx setText:@""];
            self.img1.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
            self.img2.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
            self.img3.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
            self.img4.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
            self.warnLabel.text = @"密码错误";
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
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
