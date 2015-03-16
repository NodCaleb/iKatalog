//
//  Catalogue.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 21.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Catalogue : NSObject

@property (nonatomic) int catalogue_id;
@property (strong, nonatomic) NSString *catalogueName;
@property (strong, nonatomic) NSString *catalogueURL;
@property (strong, nonatomic) NSString *catalogueDescription;
@property (strong, nonatomic) NSString *catalogueLogoUrl;
@property (strong, nonatomic) NSString *catalogueTerms;
@property (strong, nonatomic) NSString *catalogueOrderingRules;
@property (strong, nonatomic) UIImage *catalogueLogo;

- (id) initWithData:(NSDictionary *) catalogueData;

+ (NSString *) getCatalogueNameById:(int)catalogueId inArray:(NSArray *)catalogues;

@end
