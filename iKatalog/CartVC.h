//
//  CartVC.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 08.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderItem.h"
#import "Catalogue.h"
#import "AddItemVC.h"
#define ORDER_ITEMS_ARRAY_KEY @"Order items array key"

@interface CartVC : UIViewController <UITableViewDataSource, UITableViewDelegate, NSURLConnectionDelegate, SaveOrderItemProtocol>
@property (strong, nonatomic) IBOutlet UITableView *cartTableView;
@property (strong, nonatomic) NSMutableArray *orderItems;
@property (strong, nonatomic) NSMutableArray *catalogues;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *addItemButton;

- (IBAction)arrangeOrderButtonPressed:(id)sender;

@end
