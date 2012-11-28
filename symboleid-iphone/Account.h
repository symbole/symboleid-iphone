//
//  Account.h
//  symboleid-iphone
//
//  Created by Olivier GOSSE-GARDET on 20/11/12.
//  Copyright (c) 2012 Olivier GOSSE-GARDET. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Symbole;

@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * login;
@property (nonatomic, retain) NSString * password;
@property (nonatomic, retain) NSDate * timeStamp;
@property (nonatomic, retain) NSString * url;
@property (nonatomic, retain) Symbole *account_symbole;

@end
