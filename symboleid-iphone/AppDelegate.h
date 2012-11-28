//
//  AppDelegate.h
//  symboleid-iphone
//
//  Created by Olivier GOSSE-GARDET on 14/10/12.
//  Copyright (c) 2012 Olivier GOSSE-GARDET. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SIDUser;
@class SIDWebSocket;
@interface AppDelegate : UIResponder <UIApplicationDelegate>{
    SIDUser *currentUser;
    NSString *previousState;
    NSString *state;
    SIDWebSocket *websocket;
}

-(void)changeAppState:(NSString *)state;
-(void)showLoginView;
-(void)showCreateAccountView;
-(void)showFirstView;


- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;


//@property (strong, nonatomic) UINavigationController *navigationController;
@property (strong, nonatomic) UITabBarController *tabBarController;


@property (strong, nonatomic) SIDUser *currentUser;
@property (strong, nonatomic) NSString *previousState;
@property (strong, nonatomic) NSString *state;
@property (strong, nonatomic) SIDWebSocket *websocket;

@property (strong, nonatomic) UIWindow *window;



@end
