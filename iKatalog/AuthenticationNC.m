//
//  AuthenticationNC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 10.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "AuthenticationNC.h"
#import "LoginVC.h"

@interface AuthenticationNC ()

@end

@implementation AuthenticationNC

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self checkLogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) checkLogin
{
    NSArray *userDataArray = [[NSUserDefaults standardUserDefaults] arrayForKey:USER_ARRAY_KEY];
    if (userDataArray) [self performSegueWithIdentifier:@"showAccountVC" sender:self];
    else [self performSegueWithIdentifier:@"showLoginVC" sender:self];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
