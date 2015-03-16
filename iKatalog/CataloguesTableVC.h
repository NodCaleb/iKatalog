//
//  CataloguesTableVC.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 20.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalogue.h"

@interface CataloguesTableVC : UITableViewController <SQLClientDelegate>

//@property (strong, nonatomic) MSSQLData *dataSourceSQL;
@property (strong, nonatomic) NSMutableArray *catalogues;
@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *spinner;

@end
