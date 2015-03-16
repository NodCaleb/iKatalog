//
//  CatalogueDetailsVC.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 21.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalogue.h"

@interface CatalogueDetailsVC : UIViewController

@property (strong, nonatomic) Catalogue *currentCatalogue;
@property (strong, nonatomic) IBOutlet UIImageView *logoImageView;
@property (strong, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (strong, nonatomic) IBOutlet UILabel *termsLabel;
@property (strong, nonatomic) IBOutlet UILabel *orderingRulesLabel;

@end
