//
//  Record.m
//  Voice Journal
//
//  Created by Joe on 16/4/5.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import "Record.h"

@implementation Record
-(void)createDirWithName:(NSString *)name{
    NSString *documentsPath =[self getDoc];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:name];
    // 创建目录
    [fileManager createDirectoryAtPath:testDirectory withIntermediateDirectories:YES attributes:nil error:nil];
}
-(NSString *)getDoc{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return documentsDirectory;
}
-(NSString *)createFileWithFileName:(NSString *)filename andDocName:(NSString *)docName{
    NSString *documentsPath =[self getDoc];
    NSString *testDirectory = [documentsPath stringByAppendingPathComponent:docName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *testPath = [testDirectory stringByAppendingPathComponent:filename];
    [fileManager createFileAtPath:testPath contents:nil attributes:nil];
    return testPath;
}
-(NSString *)getTime{
    NSDate * date = [NSDate date];
    NSTimeInterval sec = [date timeIntervalSinceNow];
    NSDate * currentDate = [[NSDate alloc] initWithTimeIntervalSinceNow:sec];
    NSDateFormatter * df = [[NSDateFormatter alloc] init ];
    [df setDateFormat:@"yyyy-MM-dd HH:mm"];
    NSString * na = [df stringFromDate:currentDate];
    return na;
}
@end
