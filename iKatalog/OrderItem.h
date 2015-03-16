//
//  OrderItem.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 07.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <Foundation/Foundation.h>
#define CATALOGUE_ID @"catalogueId"
#define ARTICLE_NUMBER @"number"
#define ARTICLE_NAME @"name"
#define ARTICLE_PRICE @"price"
#define ARTICLE_SIZE @"size"
#define ARTICLE_COLOR @"color"

@interface OrderItem : NSObject

@property (nonatomic) int catalogueId;
@property (strong, nonatomic) NSString *number;
@property (strong, nonatomic) NSString *name;
@property (nonatomic) float price;
@property (strong, nonatomic) NSString *size;
@property (strong, nonatomic) NSString *color;
@property (strong, nonatomic) NSString *catalogueName;

- (id) initWithData:(NSDictionary *) orderItemData;
- (id) initWithCatalogue:(int)catalogue number:(NSString *)number name:(NSString *)name price:(float)price size:(NSString *)size andColor:(NSString *)color;
- (NSDictionary *) dictinaryFromOrderItem;


@end
