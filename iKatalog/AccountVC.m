//
//  AccountVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 10.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "AccountVC.h"
#import "AuthenticationNC.h"

@interface AccountVC ()

@end

@implementation AccountVC

- (void)viewDidLoad {
    [super viewDidLoad];

    self.navigationController.navigationItem.title = [self getUserName];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString *)getUserName;
{
    NSArray *userDataArray = [[NSUserDefaults standardUserDefaults] arrayForKey:USER_ARRAY_KEY];
    NSDictionary *userDataDictionary = [userDataArray objectAtIndex:0];
    return [NSString stringWithFormat:@"%@", userDataDictionary[@"FullName"]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)logoutButtonClick:(id)sender
{
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ARRAY_KEY];
    AuthenticationNC *navigationC = (AuthenticationNC *)self.navigationController;
    [navigationC checkLogin];
}
@end
