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

@interface CataloguesTableVC ()

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

- (void)viewDidLoad {
    [super viewDidLoad];
    
    //self.spinner.center = CGPointMake(160, 240);
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
                [self loadCatalogues:results];
                [client disconnect];
                [self.tableView reloadData];
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
//    NSLog(@"%@", data);
    for (NSArray* table in data)
        for (NSDictionary* row in table)
        {
//            NSLog(@"%@", row[@"CatalogueName"]);
//            [self.catalogues addObject:row];
            [self.catalogues addObject:[[Catalogue alloc] initWithData:row]];
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
