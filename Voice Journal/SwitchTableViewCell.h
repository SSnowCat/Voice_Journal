//
//  SwitchTableViewCell.h
//  Voice Journal
//
//  Created by Joe on 2017/2/9.
//  Copyright © 2017年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SwitchTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *cellName;
@property (weak, nonatomic) IBOutlet UISwitch *select;

@end
