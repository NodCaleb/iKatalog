//
//  OfferSiteVC.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 23.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Offer.h"

@interface OfferSiteVC : UIViewController

@property (strong, nonatomic) IBOutlet UIWebView *offerWebView;
@property (strong, nonatomic) Offer *currentOffer;

@end
