//
//  ProfileViewController.h
//  Parse-log-In
//
//  Created by Joseph on 2014/12/2.
//  Copyright (c) 2014年 dosomethingq. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ViewController.h"


@interface ProfileViewController : UIViewController
//@property (strong,nonatomic) UITextField *NameID;
//@property (strong,nonatomic) UITextField *password;


@property (weak, nonatomic) IBOutlet UIImageView *profileImage;

@property (weak, nonatomic) IBOutlet UITableView *tableView;


@property(strong,nonatomic) NSString *NameID;
@property(strong,nonatomic) NSString *email;
@property(strong,nonatomic) NSString *phone;


@end
