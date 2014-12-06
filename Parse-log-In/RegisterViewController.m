//
//  RegisterViewController.m
//  Parse-log-In
//
//  Created by Joseph on 2014/12/2.
//  Copyright (c) 2014年 dosomethingq. All rights reserved.
//

#import "RegisterViewController.h"
#import <Parse/Parse.h>
#import "ProfileViewController.h"

@interface RegisterViewController ()

@property (weak, nonatomic) IBOutlet UITextField *password;

@end

@implementation RegisterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewWillAppear:(BOOL)animated{
    [self.navigationController setNavigationBarHidden:YES animated:NO];

}

- (IBAction)register:(id)sender {
    
    PFUser *user = [PFUser user];
    user.username = self.nameID.text;
    user.password = self.password.text;
    user.email = self.email.text;

    
    // other fields can be set just like with PFObject
    // user[@"phone"] = @"415-392-0202";
    
    [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (!error) {
            // Hooray! Let them use the app now.
            [user saveInBackground];
            NSLog(@"Register success");
           [self performSegueWithIdentifier:@"Show profile VC" sender:nil];
            
        } else {
            NSString *errorString = [error userInfo][@"error"];
            // Show the errorString somewhere and let the user try again.
            
            UIAlertController * alert=   [UIAlertController
                                          alertControllerWithTitle:nil
                                          message:@"Please make sure your Name , Password are correct"
                                          preferredStyle:UIAlertControllerStyleAlert];
            
            
            UIAlertAction* ok = [UIAlertAction
                                 actionWithTitle:@"OK"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
            
            [alert addAction:ok];
            
            [self presentViewController:alert animated:YES completion:nil];
            
            
            
            NSLog(@"Please make sure your name , password are correct");

        
            
            
        }
    }];
    
}




-(void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"Show profile VC"]){
        ProfileViewController* vc = segue.destinationViewController;
        vc.NameID=self.nameID.text;
        
        NSLog(@"VC name is : %@",vc.NameID);
        
        PFUser *currentUser = [PFUser currentUser];
        vc.email=currentUser.email;
        vc.phone=currentUser [@"phone"];
//        vc.address=currentUser[@"address"];
//        vc.productName=currentUser[@"productName"];
//        vc.milkAmount=currentUser [@"milkAmount"];
        
        
        vc.NameID=currentUser.username;
        
        
    }
}









@end
