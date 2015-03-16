//
//  LeftTableVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 17.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "LeftTableVC.h"
#import "MenuData.h"

@interface LeftTableVC ()

@end

@implementation LeftTableVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.menu = [MenuData menuItems];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return [self.menu count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"menuItemCell" forIndexPath:indexPath];
    
    NSDictionary *menuItemData = [self.menu objectAtIndex:indexPath.row];
    cell.textLabel.text = menuItemData[MENU_ITEM_TITLE];
    cell.imageView.image = [UIImage imageNamed:menuItemData[MENU_ITEM_ICON]];
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self performSegueWithIdentifier:[self segueIdentifierForIndexPathInLeftMenu:indexPath] sender:nil];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark — Helper methods

- (NSString *) segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier;
    
    if (indexPath.section == 0)
    {
        identifier = [[MenuData menuItems] objectAtIndex:indexPath.row][MENU_ITEM_SEGUE];
    }
    else
    {
        identifier = @"searchSegue"; //для результатов поиска на месте основного меню
    }
    
    return identifier;
}

@end
