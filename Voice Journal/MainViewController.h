//
//  ViewController.h
//  Voice Journal
//
//  Created by Joe on 16/3/17.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>
#import <UIKit/UIKit.h>

@interface MainViewController : UIViewController<CLLocationManagerDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (nonatomic, strong) NSString *weather;
@property (nonatomic, strong) NSString *address;
@end
