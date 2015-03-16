//
//  Catalogue.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 21.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "Catalogue.h"

@implementation Catalogue

- (id) initWithData:(NSDictionary *) catalogueData
{
    self = [super init];
    
    self.catalogue_id = [catalogueData[@"Catalogue_id"] integerValue];
    self.catalogueName = catalogueData[@"CatalogueName"];
    self.catalogueURL = catalogueData[@"URL"];
    self.catalogueDescription = catalogueData[@"CatalogueDescription"];
    self.catalogueLogoUrl = catalogueData[@"ImageURL"];
    self.catalogueTerms = catalogueData[@"Terms"];
    self.catalogueOrderingRules = catalogueData[@"OrderingRules"];
    
    return self;
}

+ (NSString *) getCatalogueNameById:(int)catalogueId inArray:(NSArray *)catalogues
{
    for (Catalogue *catalogue in catalogues)
    {
        if (catalogue.catalogue_id == catalogueId) return catalogue.catalogueName;
    }
    return @"";
}

@end
