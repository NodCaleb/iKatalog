//
//  MenuData.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 17.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "MenuData.h"

@implementation MenuData

+ (NSArray *) menuItems
{
    NSMutableArray *menuItemsData = [@[] mutableCopy];
    
    [menuItemsData addObject:@{MENU_ITEM_ID: @0, MENU_ITEM_TITLE: @"Каталоги", MENU_ITEM_SEGUE: @"catalogueSegue", MENU_ITEM_ICON: @"Menu.png"}];
    [menuItemsData addObject:@{MENU_ITEM_ID: @1, MENU_ITEM_TITLE: @"Горячие предложения", MENU_ITEM_SEGUE: @"angebotSegue", MENU_ITEM_ICON: @"Menu.png"}];
    [menuItemsData addObject:@{MENU_ITEM_ID: @2, MENU_ITEM_TITLE: @"Корзина", MENU_ITEM_SEGUE: @"orderSegue", MENU_ITEM_ICON: @"Menu.png"}];
    [menuItemsData addObject:@{MENU_ITEM_ID: @3, MENU_ITEM_TITLE: @"Информация", MENU_ITEM_SEGUE: @"infoSegue", MENU_ITEM_ICON: @"Menu.png"}];
    [menuItemsData addObject:@{MENU_ITEM_ID: @4, MENU_ITEM_TITLE: @"Личный кабинет", MENU_ITEM_SEGUE: @"accountSegue", MENU_ITEM_ICON: @"Menu.png"}];
    
    return [menuItemsData copy];
}

@end
