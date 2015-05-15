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

@interface OffersTableVC ()

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    [self.spinner setHidesWhenStopped:YES];
//    [self.spinner startAnimating];
	   
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    [client connect:@"win-sql.df-webhosting.de:5433\\SQLEXPRESS" username:@"winweb7db1" password:@"tsp061832" database:@"winweb94db1" completion:^(BOOL success)
     {
         if (success)
         {
             NSLog(@"Load started");
             [client execute:@"SELECT * from ma_SpecialOffers order by RecordDate desc" completion:^(NSArray* results)
              {
//                  [self.spinner stopAnimating];
                  [self loadOffers:results];
                  [client disconnect];
                  NSLog(@"Load finished");
                  [self.tableView reloadData];
              }];
         }
//         else
//             [self.spinner stopAnimating];
     }];
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
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


@end
