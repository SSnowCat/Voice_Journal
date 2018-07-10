//
//  ConfirmViewController.m
//  Voice Journal
//
//  Created by Joe on 16/4/24.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "ConfirmViewController.h"
#import "PassCodeViewController.h"
#import "SettingViewController.h"

@interface ConfirmViewController ()
@property (strong, nonatomic) IBOutlet UITextField *textView;
@property (strong, nonatomic) IBOutlet UIImageView *img1;
@property (strong, nonatomic) IBOutlet UIImageView *img2;
@property (strong, nonatomic) IBOutlet UIImageView *img3;
@property (strong, nonatomic) IBOutlet UIImageView *img4;
@property (strong, nonatomic) IBOutlet UILabel *warnLabel;

@end

@implementation ConfirmViewController
- (IBAction)cancel:(id)sender {
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)setUI {
    self.view.backgroundColor = [UIColor colorWithRed:144.0 / 255.0 green:200.0 / 255.0 blue:194.0 / 255.0 alpha:1.0];
    self.img1.image = [UIImage imageNamed:@"PasscodeCircle"];
    self.img2.image = [UIImage imageNamed:@"PasscodeCircle"];
    self.img3.image = [UIImage imageNamed:@"PasscodeCircle"];
    self.img4.image = [UIImage imageNamed:@"PasscodeCircle"];
    self.textView.hidden = YES;
    self.textView.keyboardType = UIKeyboardTypeNumberPad;
    [self.textView addTarget:self action:@selector(txchange:) forControlEvents:UIControlEventEditingChanged];

    //进入界面，topTX成为第一响应
    [self.textView becomeFirstResponder];
}
- (void)txchange:(UITextField *)tx {
    NSString *password = tx.text;
    if (password.length == 0) {
        self.img1.image = [UIImage imageNamed:@"PasscodeCircle"];
        self.img2.image = [UIImage imageNamed:@"PasscodeCircle"];
        self.img3.image = [UIImage imageNamed:@"PasscodeCircle"];
        self.img4.image = [UIImage imageNamed:@"PasscodeCircle"];
    }
    if (password.length == 1) {
        self.img1.image = [UIImage imageNamed:@"FilledPasscodeCircle"];
        self.img2.image = [UIImage imageNamed:@"PasscodeCircle"];
        self.img3.image = [UIImage imageNamed:@"PasscodeCircle"];
        self.img4.image = [UIImage imageNamed:@"PasscodeCircle"];
    }
    if (password.length == 2) {
        self.img2.image = [UIImage imageNamed:@"FilledPasscodeCircle"];
        self.img3.image = [UIImage imageNamed:@"PasscodeCircle"];
        self.img4.image = [UIImage imageNamed:@"PasscodeCircle"];
    }
    if (password.length == 3) {
        self.img3.image = [UIImage imageNamed:@"FilledPasscodeCircle"];
        self.img4.image = [UIImage imageNamed:@"PasscodeCircle"];
    }
    if (password.length == 4) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.img4.image = [UIImage imageNamed:@"FilledPasscodeCircle"];
        });
        if ([password isEqualToString:self.passcode]) {
            NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
            [userDefauts setObject:password forKey:@"passcode"];
            PassCodeViewController *PCVC = [self.storyboard instantiateViewControllerWithIdentifier:@"eighth_id"];
            PCVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:PCVC animated:YES completion:nil];
        } else {
            [tx setText:@""];
            dispatch_async(dispatch_get_main_queue(), ^{
                self.img1.image = [UIImage imageNamed:@"PasscodeCircle"];
                self.img2.image = [UIImage imageNamed:@"PasscodeCircle"];
                self.img3.image = [UIImage imageNamed:@"PasscodeCircle"];
                self.img4.image = [UIImage imageNamed:@"PasscodeCircle"];
            });
            self.warnLabel.text = @"密码错误";
        }
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setUI];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController.navigationBar setHidden:YES];
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
