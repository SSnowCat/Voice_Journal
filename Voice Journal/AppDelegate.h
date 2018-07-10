//
//  AppDelegate.h
//  Voice Journal
//
//  Created by Joe on 16/3/17.
//  Copyright © 2016年 Joe. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder<UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *      managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *        managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@end
