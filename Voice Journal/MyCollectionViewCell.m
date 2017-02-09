//
//  MyCollectionViewCell.m
//  Voice Journal
//
//  Created by Joe on 16/4/27.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "MyCollectionViewCell.h"

@implementation MyCollectionViewCell
-(instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        [self prepareLayout];
        
    }
    return self;
}
-(void)prepareLayout{
    self.img = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.contentView.frame.size.width, self.contentView.frame.size.height)];
    self.img.contentMode = UIViewContentModeScaleAspectFill;
    self.img.clipsToBounds = YES;
    self.timeLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-50, 80, 50, 20)];
    self.dayLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-50, 100, 50, 50)];
    self.weekLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-140, 165, 50, 20)];
    self.yearLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.contentView.frame.size.width-100, 165, 100, 20)];
    self.timeLabel.font = [UIFont fontWithName:@"Arial" size:11];
    self.dayLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:40];
    self.weekLabel.font = [UIFont fontWithName:@"Arial" size:11];
    self.yearLabel.font = [UIFont fontWithName:@"Arial" size:11];
    self.timeLabel.textColor = [UIColor colorWithRed:143.0/255.0 green:142.0/255.0 blue:148.0/255.0 alpha:1.0];
    self.weekLabel.textColor = [UIColor colorWithRed:143.0/255.0 green:142.0/255.0 blue:148.0/255.0 alpha:1.0];
    self.dayLabel.textColor = [UIColor colorWithRed:143.0/255.0 green:142.0/255.0 blue:148.0/255.0 alpha:1.0];
    self.yearLabel.textColor = [UIColor colorWithRed:143.0/255.0 green:142.0/255.0 blue:148.0/255.0 alpha:1.0];
    self.timeLabel.textAlignment = NSTextAlignmentCenter;
    self.weekLabel.textAlignment = NSTextAlignmentCenter;
    self.dayLabel.textAlignment = NSTextAlignmentCenter;
    self.yearLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.img];
    [self.img addSubview:self.timeLabel];
    [self.img addSubview:self.weekLabel];
    [self.img addSubview:self.yearLabel];
    [self.img addSubview:self.dayLabel];}

@end
