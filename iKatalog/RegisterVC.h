//
//  RegisterVC.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 10.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterVC : UIViewController <NSURLConnectionDelegate>

@property (strong, nonatomic) IBOutlet UITextField *fullNameTextField;
@property (strong, nonatomic) IBOutlet UITextField *emailTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneTextField;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

- (IBAction)registerButtonPressed:(id)sender;

@end
