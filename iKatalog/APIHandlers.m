//
//  APIHandlers.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 01.06.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "APIHandlers.h"
#import "XMLReader.h"
#import "Catalogue.h"

@implementation APIHandlers

+ (NSMutableArray *)processCataloguesDictionary:(NSDictionary *)responseDicrionary
{
    NSMutableArray *allTheCataloguesArray = [@[] mutableCopy];
    
    NSDictionary *firstLevelDictionary = responseDicrionary[@"response"];
    NSDictionary *resultDictionary = firstLevelDictionary[@"catalogues"];
    NSArray *catalogueArray = resultDictionary[@"catalogue"];
    for (NSDictionary *catalogueData in catalogueArray)
    {
        Catalogue *newCatalogue =[[Catalogue alloc] initWithData:catalogueData];
        [allTheCataloguesArray addObject:newCatalogue];
    }
    
    return allTheCataloguesArray;
}

+ (NSString *) getResponseType:(NSDictionary *)responseDicrionary
{
    
    return responseDicrionary[@"response"][@"Type"];
}

@end
