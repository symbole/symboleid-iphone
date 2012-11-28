//
//  SIDUser.m
//  symboleid-iphone
//
//  Created by Olivier GOSSE-GARDET on 15/10/12.
//  Copyright (c) 2012 Olivier GOSSE-GARDET. All rights reserved.
//
#import "Constant.h"
#import "SIDUser.h"
#import "AFHTTPClient.h"
#import "AFJSONRequestOperation.h"
#import "AppDelegate.h"

@implementation SIDUser
@synthesize session_id;
@synthesize pin_code;
-(SIDUser *)tryLogin{
    email = @"olivier.gosse.gardet@gmail.com";
    password = @"password";
    
//    email = [[NSUserDefaults standardUserDefaults] objectForKey:@"email"];
//    password = [[NSUserDefaults standardUserDefaults] objectForKey:@"password"];
    if(email == nil || password == nil){
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] changeAppState:USER_NOT_FOUND];
        return nil;
    }else{
        [(AppDelegate *)[[UIApplication sharedApplication] delegate] changeAppState:USER_FOUND];
        [self login];
    }

    
    
    
    //    NSURL *url = [NSURL URLWithString:@"http://httpbin.org/ip"];
//    NSURLRequest *request = [NSURLRequest requestWithURL:url];
//    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
//        NSLog(@"IP Address: %@", [JSON valueForKeyPath:@"origin"]);
//        [(AppDelegate *)[[UIApplication sharedApplication] delegate] changeAppState:USER_LOGGED_IN];
//    } failure:nil];
    
//    [operation start];
    return nil;
}

-(void)login{
    AFHTTPClient *http= [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:BASE_URL]];
    [http postPath:@"/users/sign_in" parameters:@{@"user":@{@"email":email,@"password":password,@"remember_me":@"0"}}
          success:^(AFHTTPRequestOperation *operation, id responseObject) {
              NSArray *cookies = [[NSHTTPCookieStorage sharedHTTPCookieStorage] cookiesForURL: [NSURL URLWithString:BASE_URL]];
              PPLog(@"cookies %@",cookies);
              NSEnumerator *e = [cookies objectEnumerator];
              NSHTTPCookie *cookie;
              while (cookie= (NSHTTPCookie *)[e nextObject]) {
                  PPLog(@"cookies %@",[cookie name]);

                  if ([[cookie name ] isEqualToString:@"_symboleid_session"])  // TODO controle sur le domaine
                  {
                      self.session_id = [cookie value];
                  }
              }
              [(AppDelegate *)[[UIApplication sharedApplication] delegate] changeAppState:USER_LOGGED_IN];

              
          }
    
          failure:^( AFHTTPRequestOperation *operation , NSError *error ){
              [(AppDelegate *)[[UIApplication sharedApplication] delegate] changeAppState:USER_LOGIN_ERROR];
          }
     ];
}


@end
