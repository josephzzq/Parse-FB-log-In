//
//  ViewController.m
//  Parse-log-In
//
//  Created by Joseph on 2014/11/26.
//  Copyright (c) 2014年 dosomethingq. All rights reserved.
//

#import "ViewController.h"
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AFNetworking.h"
#import "AFHTTPClient.h"



@interface ViewController ()


@property (weak, nonatomic) IBOutlet UITextField *password;

//@property (strong,nonatomic)ProfileViewController *vc;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    FBLoginView *loginView =[[FBLoginView alloc] initWithReadPermissions:@[@"public_profile", @"email", @"user_friends"]];
    loginView.center = self.view.center;
    [self.view addSubview:loginView];
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        // do stuff with the user
        [self performSegueWithIdentifier:@"Show main view controller" sender:nil];
        NSLog(@"current user is %@",currentUser.email);
        //self.email=currentUser.email;
    } else {
        // show the signup or login screen
    }
    
    
    
    
    [self getFBInfor];
    
    
    
}


-(void)viewWillAppear:(BOOL)animated{
     PFUser *currentUser = [PFUser currentUser];
    if(!currentUser){
    
    [PFUser logInWithUsernameInBackground:self.NameID.text password:self.password.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {
                                    
                                            
                                            [self performSegueWithIdentifier:@"Show main view controller" sender:nil];
                                        
                                            NSLog(@"Log-in Success");

                                            // Do stuff after successful login.
                                        } else {
                                            // The login failed. Check error to see why.
                                            
                                            
                                            UIAlertController * alert=   [UIAlertController
                                                                          alertControllerWithTitle:nil
                                                                          message:@" 請登入會員或註冊帳號 "
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
    
}

- (IBAction)login:(id)sender {
    
    [PFUser logInWithUsernameInBackground:self.NameID.text password:self.password.text
                                    block:^(PFUser *user, NSError *error) {
                                        if (user) {


                                    
                                            NSLog(@"Log-in Success");
                                            //NSLog(@"nameID is:%@",self.NameID.text);
                                            


                                            [self performSegueWithIdentifier:@"Show main view controller" sender:nil];
                                            
                                            // Do stuff after successful login.
                                        } else {
                                            // The login failed. Check error to see why.
                                            
                                            
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
    if([segue.identifier isEqualToString:@"Show main view controller"]){
        ProfileViewController* vc = segue.destinationViewController;
        vc.NameID=self.NameID.text;
        NSLog(@"VC name is : %@",vc.NameID);

        
        
        PFUser *currentUser = [PFUser currentUser];
        vc.email=currentUser.email;
        vc.phone=currentUser [@"phone"];
        vc.NameID=currentUser.username;
        
        
    }
}



-(void)getFBInfor{
    
    NSString *token =[FBSession activeSession].accessTokenData.accessToken;
    NSLog(@"token is : %@",token);
    
    AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:[NSURL URLWithString:@"http://106.185.54.25/"]];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            token, @"access_token",
                            nil];
    
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"POST"
                                                            path:@"api/v1/login"
                                                      parameters:params];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [httpClient registerHTTPOperationClass:[AFHTTPRequestOperation class]];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSString *tmp = [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding];
        
        // Test Log
        NSLog(@"Response: %@", tmp);
        
        NSData *jsonData = [tmp dataUsingEncoding:NSUTF8StringEncoding];
        NSError *e;
        NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingMutableContainers error:&e];
        NSArray* listData = [dict objectForKey:@"result"];
        
        NSString *RC = [NSString stringWithFormat:@"%@",  [dict objectForKey:@"RC"]];
        NSString *RM = [NSString stringWithFormat:@"%@", [dict objectForKey:@"RM"]];
        
        NSLog(@"RC: %@", RC);
        NSLog(@"RM: %@", RM);
        

            
      
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSString *err = @"請檢查網路連接狀態";
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"伺服器連線錯誤" message:err delegate:self cancelButtonTitle:@"關閉" otherButtonTitles:nil];
        [alert show];
    }];
    
    [operation start];
}


























- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




@end
