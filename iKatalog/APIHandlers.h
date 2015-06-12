//
//  APIHandlers.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 01.06.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface APIHandlers : NSObject

+ (NSMutableArray *)processCataloguesDictionary:(NSDictionary *)responseDicrionary;
+ (NSString *) getResponseType:(NSDictionary *)responseDicrionary;

@end
