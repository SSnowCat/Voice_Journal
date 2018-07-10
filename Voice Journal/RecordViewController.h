//
//  RecordViewController.h
//  Voice Journal
//
//  Created by Joe on 16/4/5.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import <UIKit/UIKit.h>

@interface RecordViewController : UIViewController<AVAudioPlayerDelegate>
@property (nonatomic, strong) NSString *      imgPath;
@property (nonatomic, strong) NSString *      text;
@property (nonatomic, strong) NSString *      imgfilename;
@property (nonatomic, strong) NSMutableArray *tagsArr;
@property (nonatomic, strong) NSString *      isStarred;
@property (nonatomic, strong) NSString *      rootView;
@property (nonatomic, strong) NSArray *       setting;
@property (nonatomic, strong) NSString *      bigDocName;
@property (nonatomic, strong) NSString *      smallDocName;
@end
