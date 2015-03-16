//
//  CatalogueSiteVC.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 21.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalogue.h"
#import "OrderItem.h"
#import "AddItemVC.h"
#define ORDER_ITEMS_ARRAY_KEY @"Order items array key"

@interface CatalogueSiteVC : UIViewController <SaveOrderItemProtocol, UIAlertViewDelegate>

@property (strong, nonatomic) Catalogue *currentCatalogue;
@property (strong, nonatomic) NSMutableArray *catalogues;
@property (strong, nonatomic) IBOutlet UIWebView *catalogueWebView;
@property (strong, nonatomic) OrderItem *currentOrderItem;

@end
