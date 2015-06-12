//
//  CataloguesTableVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 20.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "CataloguesTableVC.h"
#import "CatalogueTableViewCell.h"
#import "CatalogueSiteVC.h"
#import "CatalogueDetailsVC.h"
#import "XMLReader.h"
#import "APIHandlers.h"

@interface CataloguesTableVC ()

@property (nonatomic) NSMutableData *responseData;

@end

@implementation CataloguesTableVC

@synthesize catalogues = _catalogues;

- (NSMutableArray *)catalogues
{
    if (!_catalogues)
    {
        _catalogues = [[NSMutableArray alloc] init];
    }
    return _catalogues;
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
    
    //self.spinner.center = CGPointMake(160, 240);
    [self.spinner setHidesWhenStopped:YES];
    [self.spinner startAnimating];
    
    [self requestCataloguesDictionary];
    
//    int i = 10 / 0;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void) loadCatalogues:(NSArray *)data
{
//    NSLog(@"%@", data);
    for (NSArray* table in data)
        for (NSDictionary* row in table)
        {
//            NSLog(@"%@", row[@"CatalogueName"]);
//            [self.catalogues addObject:row];
            [self.catalogues addObject:[[Catalogue alloc] initWithData:row]];
        }
    
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.catalogues count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    CatalogueTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"catalogueCell" forIndexPath:indexPath];
    
    Catalogue *catalogueForCell = [self.catalogues objectAtIndex:indexPath.row];
    
    cell.textLabel.text = catalogueForCell.catalogueName;
    cell.detailTextLabel.text = catalogueForCell.catalogueTerms;
    cell.cellCatalogue = catalogueForCell;
    
    /*
    cell.imageView.image = [UIImage imageNamed:@"LogoPlaceholder.png"];
    
    dispatch_queue_t logoQueue = dispatch_queue_create("logos queue", NULL);
    
    dispatch_async(logoQueue, ^{
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: cellData[@"ImageURL"]]];
        
        UIImage *catalogueLogo = [UIImage imageWithData: imageData];
        CGRect logoRect;
        float aspect = catalogueLogo.size.width / catalogueLogo.size.height;
        if (aspect < 1.5f)
        {
            logoRect = CGRectMake(0.0f, 0.0f, 44.0f*aspect, 44.0f);
        }
        else
        {
            logoRect = CGRectMake(0.0f, 0.0f, 66.0f, 66.0f/aspect);
        }
        
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:logoRect];
        [cellImageView setImage:catalogueLogo];
//        UIImage *catalogueLogo = [UIImage imageWithData: imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            cell.imageView.image = catalogueLogo;
            [cell.imageView addSubview:cellImageView];
        });
    });
    */
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"showCatalogueSite"])
        if ([segue.destinationViewController isKindOfClass:[CatalogueSiteVC class]])
        {
            CatalogueTableViewCell *senderCell = (CatalogueTableViewCell *)sender;
            CatalogueSiteVC *targetVC = segue.destinationViewController;
            targetVC.currentCatalogue = senderCell.cellCatalogue;
            targetVC.catalogues = self.catalogues;
        }
    if ([segue.identifier isEqualToString:@"showCatalogueDetails"])
        if ([segue.destinationViewController isKindOfClass:[CatalogueDetailsVC class]])
        {
            CatalogueTableViewCell *senderCell = (CatalogueTableViewCell *)sender;
            CatalogueDetailsVC *targetVC = segue.destinationViewController;
            targetVC.currentCatalogue = senderCell.cellCatalogue;
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
    self.catalogues = [APIHandlers processCataloguesDictionary:responseDictionary];
    [self.tableView reloadData];
    [self.spinner stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection error");
}

@end
