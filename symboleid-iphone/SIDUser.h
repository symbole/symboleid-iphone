//
//  SIDUser.h
//  symboleid-iphone
//
//  Created by Olivier GOSSE-GARDET on 15/10/12.
//  Copyright (c) 2012 Olivier GOSSE-GARDET. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface SIDUser : NSObject{
    NSString *email;
    NSString *password;
    NSString *session_id;
    NSString *pin_code;
}

-(SIDUser *)tryLogin;

@property (nonatomic, strong)  NSString *session_id;
@property (nonatomic, strong) NSString *pin_code;

@end
