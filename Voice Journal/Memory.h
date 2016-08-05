//
//  Memory.h
//  Voice Journal
//
//  Created by Joe on 16/3/21.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Memory : NSObject
+ (NSNumber *)totalDiskSpace;
+ (NSNumber *)freeDiskSpace;
@end
