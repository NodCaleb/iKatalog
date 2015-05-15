//
//  CatalogueSiteVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 21.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "CatalogueSiteVC.h"

@interface CatalogueSiteVC ()

@end

@implementation CatalogueSiteVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    NSURL *navigationURL;
    
    if (self.currentOffer != nil)
    {
        self.navigationItem.title = self.currentOffer.articleNameRU;
        navigationURL = [NSURL URLWithString:self.currentOffer.catalogueURL];
    }
    else if (self.currentCatalogue != nil)
    {
        self.navigationItem.title = self.currentCatalogue.catalogueName;
        navigationURL = [NSURL URLWithString:self.currentCatalogue.catalogueURL];
    }
    
    NSURLRequest *openNavigationURL = [NSURLRequest requestWithURL:navigationURL];
    [self.catalogueWebView loadRequest:openNavigationURL];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showOrderFormFormCatalogue"])
        if ([segue.destinationViewController isKindOfClass:[AddItemVC class]])
        {
            AddItemVC *targetVC = segue.destinationViewController;
            targetVC.currentCatalogue = self.currentCatalogue;
            targetVC.catalogueList = self.catalogues;
            targetVC.currentOrderItem = self.currentOrderItem;
            targetVC.delegate = self;
        }
}

#pragma mark — SaveOrderItem methods

-(void)rememberCurrentItem:(OrderItem *)currentItem
{
    self.currentOrderItem = currentItem;
    //[self dismissViewControllerAnimated:YES completion:nil];
}
-(void)saveCurrentItem:(OrderItem *)currentItem
{
//    NSLog(@"Item should be saved: %@", currentItem.name);
    NSMutableArray *orderItemsArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:ORDER_ITEMS_ARRAY_KEY] mutableCopy];
    if (!orderItemsArray) orderItemsArray = [[NSMutableArray alloc] init];
    [orderItemsArray addObject:[currentItem dictinaryFromOrderItem]];
    [[NSUserDefaults standardUserDefaults] setObject:orderItemsArray forKey:ORDER_ITEMS_ARRAY_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.currentOrderItem = Nil;
    UIAlertView *cartAlert = [[UIAlertView alloc] initWithTitle:@"Готово!" message:@"Товар добавлен в корзину. Вы можете сейчас открыть корзину для оформления заказа или сделать это позже из главного меню." delegate:nil cancelButtonTitle:@"Остаться тут" otherButtonTitles:@"Перейти к оформлению заказаs", nil];
    cartAlert.delegate = self;
    [cartAlert show];
    [self.navigationController popViewControllerAnimated:NO];
}

#pragma mark — UIAlertView delegate methods

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(buttonIndex == 0)//OK button pressed
    {
        //Do nothing
    }
    else if(buttonIndex == 1)//Annul button pressed.
    {
        [self performSegueWithIdentifier:@"openCart" sender:self];
//        NSLog(@"Button 1 pressed");
    }
}

@end
