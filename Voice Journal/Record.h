//
//  Record.h
//  Voice Journal
//
//  Created by Joe on 16/4/5.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Record : NSObject
-(void)createDirWithName:(NSString *)name;
-(NSString *)getDoc;
-(NSString *)createFileWithFileName:(NSString *)filename andDocName:(NSString *)docName;
-(NSString *)getTime;
@end
