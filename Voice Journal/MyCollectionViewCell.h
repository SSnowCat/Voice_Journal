//
//  MyCollectionViewCell.h
//  Voice Journal
//
//  Created by Joe on 16/4/27.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyCollectionViewCell : UICollectionViewCell
@property (nonatomic, strong) UILabel *    timeLabel;
@property (nonatomic, strong) UILabel *    dayLabel;
@property (nonatomic, strong) UILabel *    weekLabel;
@property (nonatomic, strong) UILabel *    yearLabel;
@property (nonatomic, strong) UIImageView *img;

- (void)prepareLayout;
@end
