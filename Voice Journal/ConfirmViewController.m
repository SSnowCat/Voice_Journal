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
    NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
    [userDefauts setBool:NO forKey:@"password"];
    SettingViewController *SVC = [self.storyboard instantiateViewControllerWithIdentifier:@"third_id"];
    [self.navigationController pushViewController:SVC animated:YES];

}
-(void)setUI{
    self.view.backgroundColor = [UIColor colorWithRed:144.0/255.0 green:200.0/255.0 blue:194.0/255.0 alpha:1.0];
    self.img1.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
    self.img2.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
    self.img3.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
    self.img4.image = [UIImage imageNamed:@"Oval 133 Copy 3@2x.png"];
    self.textView.hidden = YES;
    self.textView.keyboardType = UIKeyboardTypeNumberPad;
    [self.textView addTarget:self action:@selector(txchange:) forControlEvents:UIControlEventEditingChanged];
    
    //进入界面，topTX成为第一响应
    [self.textView becomeFirstResponder];
}
- (void)txchange:(UITextField *)tx
{
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
        if ([password isEqualToString:self.passcode]) {
            NSUserDefaults *userDefauts = [NSUserDefaults standardUserDefaults];
            [userDefauts setObject:password forKey:@"passcode"];
            PassCodeViewController *PCVC = [self.storyboard instantiateViewControllerWithIdentifier:@"eighth_id"];
            PCVC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
            [self presentViewController:PCVC animated:YES completion:nil];
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
-(void)viewWillAppear:(BOOL)animated{
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
