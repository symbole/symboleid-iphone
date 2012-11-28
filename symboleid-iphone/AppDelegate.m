//
//  AppDelegate.m
//  symboleid-iphone
//
//  Created by Olivier GOSSE-GARDET on 14/10/12.
//  Copyright (c) 2012 Olivier GOSSE-GARDET. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"
#import "AFJSONRequestOperation.h"
#import "Constant.h"
#import "SIDUser.h"
#import "SIDWebSocket.h"
#import "MasterViewController.h"
#import "PasteWebViewController.h"

#import "Symbole.h"
#import "Account.h"


@implementation AppDelegate

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;
@synthesize currentUser;
@synthesize state;
@synthesize previousState;
@synthesize websocket;
-(void)data{
    Account *account = (Account *)[NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    [account setName:@"apila"];
    [account setUrl:@"http://www.apila.fr"];
    [account setLogin:@"oliviergg"];
    [account setPassword:@"password1"];

    
    account = (Account *)[NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    [account setName:@"gmail"];
    [account setUrl:@"http://www.gmail.com"];
    [account setLogin:@"olivier.gosse.gardet@gmail.com"];
    [account setPassword:@"password2"];

    account = (Account *)[NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:_managedObjectContext];
    [account setName:@"facebook"];
    [account setUrl:@"http://www.facebook.com"];
    [account setLogin:@"olivier.gosse.gardet@gmail.com"];
    [account setPassword:@"password3"];

    
    
    NSError *error = nil;
    if (![_managedObjectContext save:&error]) {
        PPLog(@"error %@",error );
    }

}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    [self addAllObservers];
    
    currentUser = [[SIDUser alloc] init];

    // Override point for customization after application launch.
    
    MasterViewController *masterViewController = [[MasterViewController alloc] initWithNibName:@"MasterViewController" bundle:nil];
    masterViewController.managedObjectContext = self.managedObjectContext;
    UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];

    PasteWebViewController *pasteWebViewController = [[PasteWebViewController alloc] initWithNibName:@"PasteWebViewController" bundle:nil];


    
    self.tabBarController = [[UITabBarController alloc] init];
    self.tabBarController.viewControllers = @[ pasteWebViewController,navigationController];
//    self.tabBarController.viewControllers = @[navigationController];

    self.window.rootViewController = self.tabBarController;


//    [self data];
    
//    self.viewController = [[ViewController alloc] initWithNibName:@"ViewController" bundle:nil];
//    self.window.rootViewController = self.navigationController;
    [self.window makeKeyAndVisible];

    [self changeAppState:@"TRYLOGIN"];
    


    
    // Launch :
    // If a user already store in NSUser => Créate a SIDUser with his info
    // + Try to log. If log in succeed go to other
    // else connection/account creation
    

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void)showLoginView{
    PPLog(@"--");
}
-(void)showFirstView{
    PPLog(@"--");
}
-(void)showCreateAccountView{
     PPLog(@"--");
}
-(void)changeAppState:(NSString *)_state{
    PPLog(@"--");
    [[NSNotificationCenter defaultCenter] postNotification:[NSNotification notificationWithName:@"changeAppState"
                                                                                         object:self userInfo:@{@"state":_state}]];
}
-(void)manageAppState:(NSNotification *)notification{
    previousState = state;
    state = [[notification userInfo] valueForKey:@"state"];
    PPLog(@"-- %@",state);
    if([state isEqualToString:TRYLOGIN]){
      [currentUser tryLogin];
    }else if([state isEqualToString:USER_NOT_FOUND]){
      [self showLoginView];
    }else if([state isEqualToString:USER_FOUND]){
        // Do something
    }else if([state isEqualToString:USER_LOGGED_IN]){
        [self showFirstView];
        self.websocket = [[SIDWebSocket alloc] init];
        [websocket start:currentUser.session_id];
    }else if([state isEqualToString:CONNECTED]){
//        Symbole *symbole = (Symbole *)[NSEntityDescription insertNewObjectForEntityForName:@"Symbole" inManagedObjectContext:_managedObjectContext];
//        [symbole setName:@"Name"];
//        NSError *error = nil;
//        if (![_managedObjectContext save:&error]) {
//            PPLog(@"error %@",error );
//        }

        // Do something
    }else if([state isEqualToString:USER_LOGIN_ERROR]){
        // Do Something
    }else{
        PPLog(@"UNKNOWN STATE %@",state);
    }
    
}
-(void)askPinCode:(NSNotification *)n{
    PPLog(@"%@",n);
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] websocket] setPinHash:nil];
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                      message:[NSString stringWithFormat:@"Pin Code on your web browser is %@",currentUser.pin_code]
                                                     delegate:self
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Ok", nil];
    message.tag = 0;
    [message show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    PPLog(@"clicked : %d",buttonIndex);
    if(buttonIndex == 1){
        NSString *toAccepthash =[[(AppDelegate *)[[UIApplication sharedApplication] delegate] websocket] toAcceptPinHash];
        [[(AppDelegate *)[[UIApplication sharedApplication] delegate] websocket] setPinHash:toAccepthash];
        [[(AppDelegate *)[[UIApplication sharedApplication] delegate] websocket] sendMessage:@{@"cmd":@"accept_pin_code",@"args":@{}}];
    }else{
        [[(AppDelegate *)[[UIApplication sharedApplication] delegate] websocket] sendMessage:@{@"cmd":@"cancel_pin_code",@"args":@{}}];
    }
}

-(void)addAllObservers{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(manageAppState:) name:@"changeAppState" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(askPinCode:) name:NotifAskPinCode object:nil];
}
- (void)saveContext
{
    NSError *error = nil;
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

#pragma mark - Core Data stack

// Returns the managed object context for the application.
// If the context doesn't already exist, it is created and bound to the persistent store coordinator for the application.
- (NSManagedObjectContext *)managedObjectContext
{
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (coordinator != nil) {
        _managedObjectContext = [[NSManagedObjectContext alloc] init];
        [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    }
    return _managedObjectContext;
}

// Returns the managed object model for the application.
// If the model doesn't already exist, it is created from the application's model.
- (NSManagedObjectModel *)managedObjectModel
{
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"SIDModel" withExtension:@"mom"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

// Returns the persistent store coordinator for the application.
// If the coordinator doesn't already exist, it is created and the application's store added to it.
- (NSPersistentStoreCoordinator *)persistentStoreCoordinator
{
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"test6.sqlite"];
    
    NSError *error = nil;
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         
         Typical reasons for an error here include:
         * The persistent store is not accessible;
         * The schema for the persistent store is incompatible with current managed object model.
         Check the error message to determine what the actual problem was.
         
         
         If the persistent store is not accessible, there is typically something wrong with the file path. Often, a file URL is pointing into the application's resources directory instead of a writeable directory.
         
         If you encounter schema incompatibility errors during development, you can reduce their frequency by:
         * Simply deleting the existing store:
         [[NSFileManager defaultManager] removeItemAtURL:storeURL error:nil]
         
         * Performing automatic lightweight migration by passing the following dictionary as the options parameter:
         @{NSMigratePersistentStoresAutomaticallyOption:@YES, NSInferMappingModelAutomaticallyOption:@YES}
         
         Lightweight migration will only work for a limited set of schema changes; consult "Core Data Model Versioning and Data Migration Programming Guide" for details.
         
         */
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationDocumentsDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}


@end
