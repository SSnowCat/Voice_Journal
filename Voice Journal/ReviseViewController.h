//
//  ReviseViewController.h
//  Voice Journal
//
//  Created by Joe on 16/5/3.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ReviseViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
@property (nonatomic, strong) NSString *bigDocName;
@property (nonatomic, strong) NSString *smallDocName;
@property (nonatomic, strong) NSArray *setting;
@property (nonatomic, strong) NSString *imgPath;
@property (nonatomic, strong) NSString *voicePath;
@property (nonatomic, strong) NSString *contentText;
@property (nonatomic, strong) NSMutableArray *tagsArr;
@property (nonatomic, assign) NSString *starclickCount;
@property (nonatomic, strong) NSString *recordPath;
@property (nonatomic, strong) NSString *rootView;
@end
