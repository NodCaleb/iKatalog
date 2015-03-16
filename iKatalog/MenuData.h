//
//  MenuData.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 17.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <Foundation/Foundation.h>

#define MENU_ITEM_ID @"Menu item ID"
#define MENU_ITEM_TITLE @"Menu item title"
#define MENU_ITEM_SEGUE @"Menu item segue"
#define MENU_ITEM_ICON @"Icon on the left"

@interface MenuData : NSObject

+ (NSArray *) menuItems;

@end
