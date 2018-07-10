//
//  EditViewController.h
//  Voice Journal
//
//  Created by Joe on 16/4/17.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EditViewController : UIViewController<UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSString *      imgFileName;
@property (nonatomic, strong) NSString *      imgPath;
@property (nonatomic, strong) NSString *      voicePath;
@property (nonatomic, strong) NSString *      recordFileName;
@property (nonatomic, strong) NSString *      contentText;
@property (nonatomic, strong) NSMutableArray *tagsArr;
@property (nonatomic, assign) NSString *      starclickCount;
@end
