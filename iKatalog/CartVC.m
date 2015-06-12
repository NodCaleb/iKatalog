//
//  CartVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 08.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "CartVC.h"
#import "APIHandlers.h"
#import "XMLReader.h"

@interface CartVC ()

@property (nonatomic) NSMutableData *responseData;

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

@synthesize responseData = _responseData;

- (NSMutableData *)responseData
{
    if (!_responseData)
    {
        _responseData = [[NSMutableData alloc] init];
    }
    return _responseData;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.cartTableView.delegate = self;
    self.cartTableView.dataSource = self;
    
    [self.spinner setHidesWhenStopped:YES];
    [self.spinner startAnimating];
    
    [self requestCataloguesDictionary];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    CGRect rect = self.navigationController.navigationBar.frame;
    float y = rect.size.height + rect.origin.y;
    self.cartTableView.contentInset = UIEdgeInsetsMake(y ,0,0,0);
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
//    NSError *error;
//    
//    NSMutableArray *ordersArray = [@[] mutableCopy];
//    
//    for (OrderItem *currentItem in self.orderItems)
//    {
//        [ordersArray addObject:[currentItem dictinaryFromOrderItem]];
//    }
//    
//    NSDictionary *userDataDictionary = [[NSUserDefaults standardUserDefaults] dictionaryForKey:USER_DICTIONARY_KEY];
//    
//    if ([NSJSONSerialization isValidJSONObject:ordersArray] && userDataDictionary)
//    {
//        NSData *newJsonData = [NSJSONSerialization dataWithJSONObject:ordersArray options:NSJSONWritingPrettyPrinted error:&error];
//        
//        NSString *orderContentString;
//        if (! newJsonData) {
//            NSLog(@"Got an error: %@", error);
//        } else {
//            orderContentString = [[NSString alloc] initWithData:newJsonData encoding:NSUTF8StringEncoding];
//        }
//        int customerId = [userDataDictionary[@"Customer_id"] integerValue];
//        [self requestArrangeOrderWithContent:orderContentString forCustomer:customerId];
//    }
    [self performSegueWithIdentifier:@"showCheckout" sender:nil];
}

- (void)requestCataloguesDictionary
{
    [self.responseData setLength:0];
    NSString *post = [NSString stringWithFormat: @"action=getCatalogues&appId=%@", ASP_APPLICATION_ID];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:ASP_REQUEST_HANDLER_URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20.0];
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
}

- (void)requestArrangeOrderWithContent:(NSString*) orderContent forCustomer:(int)customerId
{
    [self.responseData setLength:0];
    NSString *post = [NSString stringWithFormat: @"action=arrangeOrder&appId=%@&orderContent=%@&customer=%i", ASP_APPLICATION_ID, orderContent, customerId];
    NSData *postData = [post dataUsingEncoding:NSASCIIStringEncoding allowLossyConversion:YES];
    NSString *postLength = [NSString stringWithFormat:@"%d", [postData length]];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init] ;
    [request setURL:[NSURL URLWithString:ASP_REQUEST_HANDLER_URL]];
    [request setHTTPMethod:@"POST"];
    [request setValue:postLength forHTTPHeaderField:@"Content-Length"];
    [request setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setTimeoutInterval:20.0];
    [request setHTTPBody:postData];
    
    [NSURLConnection connectionWithRequest:request delegate:self];
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



#pragma mark NSURLConnection Delegate Methods
- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    //    _responseData = [[NSMutableData alloc] init];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [self.responseData appendData:data];
}

- (NSCachedURLResponse *)connection:(NSURLConnection *)connection willCacheResponse:(NSCachedURLResponse*)cachedResponse
{
    return nil;
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSError * error = nil;
    NSDictionary *responseDictionary = [XMLReader dictionaryForXMLData:self.responseData error:&error];
    
    NSString *responseType = [APIHandlers getResponseType:responseDictionary];
    if ([responseType isEqualToString:@"catalogues"])
    {
        self.catalogues = [APIHandlers processCataloguesDictionary:responseDictionary];
        [self loadCartItems];
        [self.cartTableView reloadData];
        self.addItemButton.enabled = YES;
        [self.spinner stopAnimating];
    }
    
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection error");
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
