//
//  OffersTableVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 23.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "OffersTableVC.h"
#import "OfferTableViewCell.h"
#import "OfferSiteVC.h"
#import "CatalogueSiteVC.h"
#import "XMLReader.h"

@interface OffersTableVC ()

@property (nonatomic) NSMutableData *responseData;

@end

@implementation OffersTableVC

@synthesize offers = _offers;

- (NSMutableArray *)offers
{
    if (!_offers)
    {
        _offers = [[NSMutableArray alloc] init];
    }
    return _offers;
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
    
    [self.spinner setHidesWhenStopped:YES];
    [self.spinner startAnimating];
    
    [self requestOffersDictionary];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) loadOffers:(NSArray *)data
{
    for (NSArray* table in data)
        for (NSDictionary* row in table)
        {
            [self.offers addObject:[[Offer alloc] initWithData:row]];
        }
}

- (void)requestOffersDictionary
{
    [self.responseData setLength:0];
    NSString *post = [NSString stringWithFormat: @"action=getOffers&appId=%@", ASP_APPLICATION_ID];
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

- (NSMutableArray *)processOffersDictionary:(NSDictionary *)responseDicrionary
{
    NSMutableArray *allTheOfferArray = [@[] mutableCopy];
    
    NSDictionary *firstLevelDictionary = responseDicrionary[@"response"];
    NSDictionary *resultDictionary = firstLevelDictionary[@"offers"];
    NSArray *offerArray = resultDictionary[@"offer"];
    for (NSDictionary *offerData in offerArray)
    {
        Offer *newOffer =[[Offer alloc] initWithData:offerData];
        [allTheOfferArray addObject:newOffer];
    }
    
    return allTheOfferArray;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.offers count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OfferTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"offerCell" forIndexPath:indexPath];
    
    Offer *offerForCell = [self.offers objectAtIndex:indexPath.row];
    
    cell.textLabel.text = offerForCell.articleNameRU;
    cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ / %.2f €", offerForCell.catalogueName, offerForCell.price];
    cell.cellOffer = offerForCell;
    
    if (offerForCell.offerImage == nil)
    {
        UIActivityIndicatorView *cellSpinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        cellSpinner.frame = CGRectMake(0, 0, 44, 44);
        [cell.imageView addSubview:cellSpinner];
        [cellSpinner startAnimating];
        
        dispatch_queue_t imageQueue = dispatch_queue_create("images queue", NULL);
        
        dispatch_async(imageQueue, ^{
            NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString: offerForCell.imageURL]];
            UIImage *loadedOfferImage = [UIImage imageWithData: imageData];
            CGSize newSize = CGSizeMake(44, 44);
            UIImage *resizedImage = [self resizeImage:loadedOfferImage toSize:newSize];
            CGRect imageRect = CGRectMake(0,0,44,44);
            UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:imageRect];
            cellImageView.contentMode = UIViewContentModeCenter;
            cellImageView.contentMode = UIViewContentModeScaleAspectFit;
            [cellImageView setImage:resizedImage];
            [cellSpinner stopAnimating];
            offerForCell.offerImage = resizedImage;
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [cell.imageView addSubview:cellImageView];
            });
        });
    }
    else
    {
        CGRect imageRect = CGRectMake(0,0,44,44);
        UIImageView *cellImageView = [[UIImageView alloc] initWithFrame:imageRect];
        cellImageView.contentMode = UIViewContentModeCenter;
        cellImageView.contentMode = UIViewContentModeScaleAspectFit;
        [cellImageView setImage:offerForCell.offerImage];
        [cell.imageView addSubview:cellImageView];
    }
    
    return cell;
}

-(UIImage*)resizeImage:(UIImage*)image toSize:(CGSize)newSize
{
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
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
    if ([segue.identifier isEqualToString:@"openOffer"]) //В данный момент не используется
        if ([segue.destinationViewController isKindOfClass:[OfferSiteVC class]])
        {
            OfferTableViewCell *senderCell = (OfferTableViewCell *)sender;
            OfferSiteVC *targetVC = segue.destinationViewController;
            targetVC.currentOffer = senderCell.cellOffer;
        }
    if ([segue.identifier isEqualToString:@"showOfferOnSite"])
        if ([segue.destinationViewController isKindOfClass:[CatalogueSiteVC class]])
        {
            OfferTableViewCell *senderCell = (OfferTableViewCell *)sender;
            CatalogueSiteVC *targetVC = segue.destinationViewController;
            targetVC.currentOffer = senderCell.cellOffer;
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
    self.offers = [self processOffersDictionary: responseDictionary];
    [self.tableView reloadData];
    [self.spinner stopAnimating];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection error");
}



@end
