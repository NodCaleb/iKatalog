//
//  LoginVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 10.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "LoginVC.h"
#import "AuthenticationNC.h"
#import "XMLReader.h"

@interface LoginVC ()

@property (nonatomic) NSMutableData *responseData;

@end

@implementation LoginVC

@synthesize responseData = _responseData;

- (NSMutableData *)responseData
{
    if (!_responseData)
    {
        _responseData = [[NSMutableData alloc] init];
    }
    return _responseData;
}

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
    
    NSString *post = [NSString stringWithFormat: @"action=login&appId=%@&userName=%@&password=%@", ASP_APPLICATION_ID, self.loginTextField.text, self.passTextField.text];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:ASP_REQUEST_HANDLER_URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20.0];
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
    
}

- (void)processResponseDictionary:(NSDictionary *)responseDicrionary
{
    NSDictionary *firstLevelDictionary = responseDicrionary[@"response"];
    NSDictionary *resultDictionary = firstLevelDictionary[@"result"];
    NSDictionary *userDictionary = firstLevelDictionary[@"user"];
    //    NSLog(@"%@", resultDictionary);
    int resultCode = [resultDictionary[@"text"] integerValue];
    if (resultCode == 0)
    {
        [[NSUserDefaults standardUserDefaults] setObject:userDictionary forKey:USER_DICTIONARY_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        if ([self checkUser]) [self performLogin];
    }
    else if (resultCode == 6)
    {
        UIAlertView *cartAlert = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Неверное имя пользователя или пароль." delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil];
        [cartAlert show];
    }
    else if (resultCode == 5)
    {
        UIAlertView *cartAlert = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Ошибка связи, пожалуйста, попробуйте позже." delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil];
        [cartAlert show];
    }
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
//    NSArray *userDataArray = [[NSUserDefaults standardUserDefaults] arrayForKey:USER_ARRAY_KEY];
    NSDictionary *userDataDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:USER_DICTIONARY_KEY];
    if (userDataDictionary) return YES;
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


#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
        _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError * error = nil;
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLData:self.responseData error:&error];
    [self processResponseDictionary:responseDictionary];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection error");
}

@end
