//
//  RegisterVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 10.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "RegisterVC.h"
#import "XMLReader.h"

@interface RegisterVC ()

@property (nonatomic) NSMutableData *responseData;

@end

@implementation RegisterVC

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
    self.navigationController.navigationItem.title = @"Регистрация";
    // Do any additional setup after loading the view.
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

- (IBAction)registerButtonPressed:(id)sender
{
    if ([self.fullNameTextField.text isEqualToString:@""]||[self.emailTextField.text isEqualToString:@""]||[self.phoneTextField.text isEqualToString:@""])
    {
        UIAlertView *formAlert = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Пожалуйста заполните полное имя, email и телефон." delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil];
        [formAlert show];
        return;
    }
    [self makeRegisterRequestForName:self.fullNameTextField.text email:self.emailTextField.text andPhone:self.phoneTextField.text];
}

- (void)makeRegisterRequestForName:(NSString *)userName email:(NSString *)email andPhone:(NSString *)phone
{
    [self.responseData setLength:0];
    NSString *post = [NSString stringWithFormat: @"action=register&appId=%@&userName=%@&mail=%@&phone=%@", ASP_APPLICATION_ID, userName, email, phone];
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
//    NSLog(@"%@", resultDictionary);
    int resultCode = [resultDictionary[@"text"] integerValue];
    if (resultCode == 0)
    {
        UIAlertView *formAlert = [[UIAlertView alloc] initWithTitle:@"Поздравляем!" message:@"Регистрация прошла успешно\nВаш пароль другую полезную информацию мы выслали вам на почту" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil];
        [formAlert show];
    }
    else if (resultCode == 3)
    {
        UIAlertView *formAlert = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Пользователь с таким адресом электронной почты существует\nПожалуйста укажите другой" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil];
        [formAlert show];
    }
    else if (resultCode == 4)
    {
        UIAlertView *formAlert = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Регистрация не удалась\nКакая-то ошибка на сайте iKatalog, где должна была выполнена регистрация" delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil];
        [formAlert show];
    }
}


#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
//    _responseData = [[NSMutableData alloc] init];
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
