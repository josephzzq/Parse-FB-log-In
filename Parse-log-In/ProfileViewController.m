//
//  ProfileViewController.m
//  Parse-log-In
//
//  Created by Joseph on 2014/12/2.
//  Copyright (c) 2014年 dosomethingq. All rights reserved.
//

#import "ProfileViewController.h"
#import <Parse/Parse.h>

@interface ProfileViewController () <UITableViewDataSource,UITableViewDataSource>

@end

@implementation ProfileViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.navigationController setNavigationBarHidden:YES animated:NO];

    
    
    PFUser *currentUser = [PFUser currentUser];
    
    if (currentUser) {
        // do stuff with the user
        NSLog(@"current user is %@",currentUser.email);
    } else {
        // show the signup or login screen
    }
    
   // self.tableView.backgroundColor = [UIColor clearColor];
    
    
    [self getPicture];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)logout:(id)sender {

    [PFUser logOut];

}

-(void) getPicture{
    
    
    PFQuery *query = [PFUser query];
    
    
    // Add constraints here to get the image you want (like the objectId or something else)
    // [query whereKey:@"username" containedIn:object];
    
   // self.NameID=self.nameid.NameID.text;

    
    [query whereKey:@"username" containsString:self.NameID];
    NSLog(@"name is %@",self.NameID);

    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if ([objects count] != 0) {
            NSLog(@"objects: %@", objects);
            for (PFObject *object in objects) {
                PFFile *imageFile = object[@"image"];
                [imageFile getDataInBackgroundWithBlock:^(NSData *imageData, NSError *error) {
                    if (!error) {
                        
                        UIImage *image = [UIImage imageWithData:imageData];  // Here is your image. Put it in a UIImageView or whatever
                        
                        UIImageView *imageView = [[UIImageView alloc] initWithImage:image] ;
                        
                        imageView.frame=CGRectMake(140, 50, 90 , 90);
                        imageView.clipsToBounds=YES;
                        [imageView.layer setCornerRadius:imageView.bounds.size.width/2];
                        [self.view addSubview:imageView];
                        
                        self.profileImage=imageView;
                    
                        //[self.profileImage setImage:image];
                        NSLog(@"nameID: %@",self.NameID);

                        
                    }
                    else{
                        NSLog(@"failure");

                    }
                }];
   }
        } else {
            // Log details of the failure
            NSLog(@"failure");
        }
    }];
    
    
    
}


-(void)getName{
 

    
    

}







#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
//{
//    return 100.0;
//}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 40.0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault  reuseIdentifier:CellIdentifier];
    }
    

            switch (indexPath.row) {
                case 0:

                    
                    cell.textLabel.text =self.NameID;
                    break;
                case 1:
                    //cell.imageView.image = [UIImage imageNamed:@"img_info_password"];
                    
                    cell.textLabel.text = self.email;
                    //[cell.contentView addSubview:user_password];
                    break;
                case 2:
                   // cell.imageView.image = [UIImage imageNamed:@"img_info_password"];
                    
                    cell.textLabel.text = self.phone;
                    //[cell.contentView addSubview:user_confirm];
                    break;
                    
                default:
                    break;
            }
    
    
    
    
    
    
        [cell setBackgroundColor:[UIColor clearColor]];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
    
    
    return cell;
}








@end
