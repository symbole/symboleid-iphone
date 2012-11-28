//
//  DetailViewController.h
//  test2
//
//  Created by Olivier GOSSE-GARDET on 19/11/12.
//  Copyright (c) 2012 Olivier GOSSE-GARDET. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *urlLabel;
@property (weak, nonatomic) IBOutlet UILabel *loginLabel;
@property (weak, nonatomic) IBOutlet UILabel *passwordLabel;


@end
