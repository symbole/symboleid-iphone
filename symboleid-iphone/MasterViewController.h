//
//  MasterViewController.h
//  test2
//
//  Created by Olivier GOSSE-GARDET on 19/11/12.
//  Copyright (c) 2012 Olivier GOSSE-GARDET. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>
@class SIDUser;
@interface MasterViewController : UITableViewController <NSFetchedResultsControllerDelegate>{
    SIDUser *currentUser;
}

@property (strong, nonatomic) DetailViewController *detailViewController;

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
