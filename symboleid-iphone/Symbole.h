//
//  Symbole.h
//  symboleid-iphone
//
//  Created by Olivier GOSSE-GARDET on 20/11/12.
//  Copyright (c) 2012 Olivier GOSSE-GARDET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Account;

@interface Symbole : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) Account *symbole_account;

@end
