//
//  TestVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 12.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "TestVC.h"

@interface TestVC ()

@end

@implementation TestVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    NSURL *navigationURL = [NSURL URLWithString:@"http://nationalbank.kz/rss/rates_all.xml"];
    NSURLRequest *openNavigationURL = [NSURLRequest requestWithURL:navigationURL];
    NSString *responeString = [self urlRequestToString:openNavigationURL];
    NSLog(@"%@",openNavigationURL);
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSString*)urlRequestToString:(NSURLRequest*)urlRequest
{
    NSString *requestPath = [[urlRequest URL] absoluteString];
    return requestPath;
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
