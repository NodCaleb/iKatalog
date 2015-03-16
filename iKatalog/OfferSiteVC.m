//
//  OfferSiteVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 23.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "OfferSiteVC.h"

@interface OfferSiteVC ()

@end

@implementation OfferSiteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationItem.title = self.currentOffer.articleNameRU;
    NSURL *navigationURL = [NSURL URLWithString:self.currentOffer.catalogueURL];
    NSURLRequest *openNavigationURL = [NSURLRequest requestWithURL:navigationURL];
    [self.offerWebView loadRequest:openNavigationURL];
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

@end
