//
//  CartVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 08.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "CartVC.h"

@interface CartVC ()

@end

@implementation CartVC

@synthesize catalogues = _catalogues;

- (NSMutableArray *)catalogues
{
    if (!_catalogues)
    {
        _catalogues = [[NSMutableArray alloc] init];
    }
    return _catalogues;
}

@synthesize orderItems = _orderItems;

- (NSMutableArray *)orderItems
{
    if (!_orderItems)
    {
        _orderItems = [[NSMutableArray alloc] init];
    }
    return _orderItems;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cartTableView.delegate = self;
    self.cartTableView.dataSource = self;
    
    [self.spinner setHidesWhenStopped:YES];
    [self.spinner startAnimating];
    
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    
    [client connect:@"win-sql.df-webhosting.de:5433\\SQLEXPRESS" username:@"winweb7db1" password:@"tsp061832" database:@"winweb94db1" completion:^(BOOL success)
     {
         if (success)
         {
             [client execute:@"SELECT * from ma_CataloguesView order by SortOrder, CatalogueName" completion:^(NSArray* results)
              {
                  [self.spinner stopAnimating];
                  self.addItemButton.enabled = YES;
                  [self loadCatalogues:results];
                  [client disconnect];
                  [self loadCartItems];
                  
                  
                  [self.cartTableView reloadData];
              }];
         }
         else
             [self.spinner stopAnimating];
     }];

    

    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadCatalogues:(NSArray *)data
{
    for (NSArray* table in data)
        for (NSDictionary* row in table)
        {
            [self.catalogues addObject:[[Catalogue alloc] initWithData:row]];
        }
    
}

-(void) loadCartItems
{
    NSMutableArray *orderItemsArray = [[[NSUserDefaults standardUserDefaults] arrayForKey:ORDER_ITEMS_ARRAY_KEY] mutableCopy];
    
    for (NSDictionary* itemDictionary in orderItemsArray)
    {
        OrderItem *item = [[OrderItem alloc] initWithData:itemDictionary];
        item.catalogueName = [Catalogue getCatalogueNameById:item.catalogueId inArray:self.catalogues];
        [self.orderItems addObject:item];
    }
}

- (IBAction)arrangeOrderButtonPressed:(id)sender
{
    
}

#pragma mark — UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.orderItems count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cartCell" forIndexPath:indexPath];
    OrderItem *cellItem = [self.orderItems objectAtIndex:indexPath.row];
    
    cell.textLabel.text = cellItem.name;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / %.2f €", cellItem.catalogueName, cellItem.price];
    
    return cell;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"showOrderFormFromCart"])
        if ([segue.destinationViewController isKindOfClass:[AddItemVC class]])
        {
            AddItemVC *targetVC = segue.destinationViewController;
            targetVC.catalogueList = self.catalogues;
            targetVC.delegate = self;
        }
}



#pragma mark - SQLClientDelegate

//Required
- (void)error:(NSString*)error code:(int)code severity:(int)severity
{
    if (code == 20042) return; //Ошибка, которую можно игнорировать, ибо она каждый раз вылезает, но соединение все-равно работает
    NSLog(@"Error #%d: %@ (Severity %d)", code, error, severity);
    [[[UIAlertView alloc] initWithTitle:@"Error" message:error delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil] show];
}

//Optional
- (void)message:(NSString*)message
{
    NSLog(@"Message: %@", message);
}

#pragma mark — SaveOrderItem methods

-(void)rememberCurrentItem:(OrderItem *)currentItem
{
//    self.currentOrderItem = currentItem;
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
//    self.currentOrderItem = Nil;
//    UIAlertView *cartAlert = [[UIAlertView alloc] initWithTitle:@"Готово!" message:@"Товар добавлен в корзину. Вы можете сейчас открыть корзину для оформления заказа или сделать это позже из главного меню." delegate:nil cancelButtonTitle:@"Остаться тут" otherButtonTitles:@"Перейти к оформлению заказаs", nil];
//    cartAlert.delegate = self;
//    [cartAlert show];
    [self loadCartItems];
    [self.cartTableView reloadData];
    [self.navigationController popViewControllerAnimated:NO];
}

@end
