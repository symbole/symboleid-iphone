//
//  ViewController.m
//  symboleid-iphone
//
//  Created by Olivier GOSSE-GARDET on 14/10/12.
//  Copyright (c) 2012 Olivier GOSSE-GARDET. All rights reserved.
//

#import "ViewController.h"
#import "Constant.h"
#import "SIDUser.h"
#import "AppDelegate.h"
#import "SIDWebSocket.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    currentUser = [(AppDelegate *)[[UIApplication sharedApplication] delegate] currentUser];

    [super viewDidLoad];
    [self addAllObserver];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)askPinCode:(NSNotification *)n{
    PPLog(@"%@",n);
    
    UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Confirmation"
                                                      message:[NSString stringWithFormat:@"Pin Code on your web browser is %@",currentUser.pin_code]
                                                     delegate:nil
                                            cancelButtonTitle:@"Cancel"
                                            otherButtonTitles:@"Ok", nil];
    [message show];
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] websocket] sendMessage:@{@"cmd":@"test",@"args":@"test"}];
}

-(void)addAllObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(askPinCode:) name:NotifAskPinCode object:nil];
}

@end
