//
//  MainVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 17.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "MainVC.h"
#import "MenuData.h"

@interface MainVC ()

@end

@implementation MainVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSString *) segueIdentifierForIndexPathInLeftMenu:(NSIndexPath *)indexPath
{
    NSString *identifier;
    
    if (indexPath.section == 0)
    {
        identifier = [[MenuData menuItems] objectAtIndex:indexPath.row][MENU_ITEM_SEGUE];
    }
    else
    {
        identifier = @"searchSegue";
    }
    
    return identifier;
}

- (void) configureLeftMenuButton:(UIButton *)button
{
    CGRect frame = button.frame;
    frame.origin = (CGPoint){0,0};
    frame.size = (CGSize){40,40};
    button.frame = frame;
    
    [button setImage:[UIImage imageNamed:@"Menu.png"] forState:UIControlStateNormal];
}

- (CGFloat) leftMenuWidth
{
    return 270;
}

- (BOOL) deepnessForLeftMenu
{
    return NO;
}

- (NSIndexPath *)initialIndexPathForLeftMenu
{
    return [NSIndexPath indexPathForRow:0 inSection:0];
}

@end
