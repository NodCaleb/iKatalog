//
//  Offer.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 23.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "Offer.h"

@implementation Offer

- (id) initWithData:(NSDictionary *) offerData
{
    self = [super init];
    
    self.catalogue_id = [offerData[@"Catalogue_id"] integerValue];
    self.catalogueName = offerData[@"CatalogueName"];
    self.articleNumber = offerData[@"Article_id"];
    self.articleNameDE = offerData[@"ArticleNameDe"];
    self.articleNameRU = offerData[@"ArticleNameRu"];
    self.price = [offerData[@"Price"] floatValue];
    self.imageURL = offerData[@"ImageUrl"];
    self.catalogueURL = offerData[@"CatalogueUrl"];    
    
    return self;
}

@end
