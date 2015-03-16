//
//  Offer.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 23.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Offer : NSObject

@property (nonatomic) int catalogue_id;
@property (strong, nonatomic) NSString *catalogueName;
@property (strong, nonatomic) NSString *articleNumber;
@property (strong, nonatomic) NSString *articleNameDE;
@property (strong, nonatomic) NSString *articleNameRU;
@property (nonatomic) float price;
@property (strong, nonatomic) NSString *imageURL;
@property (strong, nonatomic) NSString *catalogueURL;
@property (strong, nonatomic) UIImage *offerImage;

- (id) initWithData:(NSDictionary *) offerData;

@end
