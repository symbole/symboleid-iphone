//
//  DetailViewController.m
//  test2
//
//  Created by Olivier GOSSE-GARDET on 19/11/12.
//  Copyright (c) 2012 Olivier GOSSE-GARDET. All rights reserved.
//

#import "DetailViewController.h"
#import "AppDelegate.h"
#import "SIDWebSocket.h"
@interface DetailViewController ()
- (void)configureView;
-(IBAction)sendAccountInfo:(id)sender;

@end

@implementation DetailViewController

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem
{
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
        
        // Update the view.
        [self configureView];
    }
}
-(IBAction)sendAccountInfo:(id)sender{
    [[(AppDelegate *)[[UIApplication sharedApplication] delegate] websocket] proxyMessage:
     @{@"cmd":@"account_data",@"args":@{
                @"login":[self.detailItem valueForKey:@"login"],
                @"url":[self.detailItem valueForKey:@"url"],
                @"password":[self.detailItem valueForKey:@"password"]
                }
     }];

}

- (void)configureView
{
    // Update the user interface for the detail item.

    if (self.detailItem) {
        self.nameLabel.text = [[self.detailItem valueForKey:@"name"] description];
        self.urlLabel.text = [[self.detailItem valueForKey:@"url"] description];
        self.loginLabel.text = [[self.detailItem valueForKey:@"login"] description];
        self.passwordLabel.text = [[self.detailItem valueForKey:@"password"] description];
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self configureView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = NSLocalizedString(@"Detail", @"Detail");
    }
    return self;
}
							
@end
