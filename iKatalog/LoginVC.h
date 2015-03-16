//
//  LoginVC.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 10.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginVC : UIViewController <SQLClientDelegate>

@property (strong, nonatomic) IBOutlet UITextField *loginTextField;
@property (strong, nonatomic) IBOutlet UITextField *passTextField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)loginButtonPressed:(id)sender;
- (IBAction)registerButtonPressed:(id)sender;

@end
