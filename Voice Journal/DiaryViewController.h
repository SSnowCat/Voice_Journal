//
//  DiaryViewController.h
//  Voice Journal
//
//  Created by Joe on 16/4/22.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface DiaryViewController : UIViewController<AVAudioPlayerDelegate>
@property (nonatomic, strong) NSArray * setting;
@property (nonatomic, strong) NSString *bigDocName;
@property (nonatomic, strong) NSString *smallDocName;
@end
