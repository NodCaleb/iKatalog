//
//  OrderItem.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 07.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "OrderItem.h"

@implementation OrderItem

- (id) initWithData:(NSDictionary *) orderItemData
{
    self = [super init];
    
    self.catalogueId = [orderItemData[CATALOGUE_ID] integerValue];
    self.number = orderItemData[ARTICLE_NUMBER];
    self.name = orderItemData[ARTICLE_NAME];
    self.price = [orderItemData[ARTICLE_PRICE] floatValue];
    self.size = orderItemData[ARTICLE_SIZE];
    self.color = orderItemData[ARTICLE_COLOR];
    
    return self;
}
- (id) initWithCatalogue:(int)catalogue number:(NSString *)number name:(NSString *)name price:(float)price size:(NSString *)size andColor:(NSString *)color
{
    self = [super init];
    
    self.catalogueId = catalogue;
    self.number = number;
    self.name = name;
    self.price = price;
    self.size = size;
    self.color = color;
    
    return self;
}

- (NSDictionary *) dictinaryFromOrderItem
{
    NSNumber *cId = [NSNumber numberWithInt:self.catalogueId];
    NSNumber *aP = [NSNumber numberWithFloat:self.price];
    
    return @{CATALOGUE_ID : cId, ARTICLE_NUMBER : self.number, ARTICLE_NAME : self.name, ARTICLE_PRICE : aP, ARTICLE_SIZE : self.size, ARTICLE_COLOR : self.color};
}

@end
