//
//  MSSQLData.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 20.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SQLClient.h"

@interface MSSQLData : NSObject <SQLClientDelegate>

- (NSArray *) getCatalogueList;

@end
