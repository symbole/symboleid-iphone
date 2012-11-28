//
//  ViewController.m
//  testsimpleview2
//
//  Created by Olivier GOSSE-GARDET on 21/11/12.
//  Copyright (c) 2012 Olivier GOSSE-GARDET. All rights reserved.
//

#import "PasteWebViewController.h"

@interface PasteWebViewController ()

@end

@implementation PasteWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"PasteWeb", @"PasteWeb");
//        self.tabBarItem.image = [UIImage imageNamed:@"first"];
    }
    return self;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    [self addAllObserver];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)notifPastWebReceived:(NSNotification *)n{
    PPLog(@"%@",n);
    [self.pasteWebTextView setText:[n.userInfo valueForKey:@"val"]];
}

-(void)addAllObserver{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notifPastWebReceived:) name:@"NOTIF_PASTEWEB" object:nil];
}

@end
