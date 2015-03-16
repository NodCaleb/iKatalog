//
//  LoginVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 10.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "LoginVC.h"
#import "AuthenticationNC.h"

@interface LoginVC ()

@end

@implementation LoginVC

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.spinner setHidesWhenStopped:YES];
    if ([self checkUser]) [self performLogin];
    self.navigationController.navigationItem.title = @"Авторизация";
//    [[NSUserDefaults standardUserDefaults] removeObjectForKey:USER_ARRAY_KEY]; //Чисто на всемя тестирования
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)loginButtonPressed:(id)sender
{
    [self.spinner startAnimating];
    NSString *requestString = [NSString stringWithFormat:@"select * from ma_Users where Password = '%@' and (UserName = LOWER('%@') or Email = LOWER('%@'))", self.passTextField.text, self.loginTextField.text, self.loginTextField.text];
    self.loginTextField.text = @"";
    self.passTextField.text = @"";
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    [client connect:@"win-sql.df-webhosting.de:5433\\SQLEXPRESS" username:@"winweb7db1" password:@"tsp061832" database:@"winweb94db2" completion:^(BOOL success)
     {
         if (success)
         {
             [client execute:requestString completion:^(NSArray* results)
              {
                  [self.spinner stopAnimating];
                  [self authenticateUser:results];
                  [client disconnect];
                  if ([self checkUser]) [self performLogin];
                  else
                  {
                      UIAlertView *cartAlert = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Неверное имя пользователя или пароль." delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil];
                      [cartAlert show];
                  }
              }];
         }
         else [self.spinner stopAnimating];
     }];
}

- (void) authenticateUser:(NSArray *)data
{
    NSLog(@"%@", data);
    for (NSArray* table in data)
        for (NSDictionary* row in table)
        {
            NSLog(@"%@", row);
            NSMutableArray *userData = [[NSMutableArray alloc] init];
            [userData addObject:row];
            [[NSUserDefaults standardUserDefaults] setObject:userData forKey:USER_ARRAY_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
}

- (BOOL) checkUser
{
    NSArray *userDataArray = [[NSUserDefaults standardUserDefaults] arrayForKey:USER_ARRAY_KEY];
    if (userDataArray) return YES;
    else return NO;
}

- (void) performLogin
{
    AuthenticationNC *navigationC = (AuthenticationNC *)self.navigationController;
    [navigationC checkLogin];
}

- (IBAction)registerButtonPressed:(id)sender
{
    [self performSegueWithIdentifier:@"showRegisterForm" sender:self];
}

#pragma mark - SQLClientDelegate

//Required
- (void)error:(NSString*)error code:(int)code severity:(int)severity
{
    if (code == 20042) return; //Ошибка, которую можно игнорировать, ибо она каждый раз вылезает, но соединение все-равно работает
    NSLog(@"Error #%d: %@ (Severity %d)", code, error, severity);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

//Optional
- (void)message:(NSString*)message
{
    NSLog(@"Message: %@", message);
}

@end
