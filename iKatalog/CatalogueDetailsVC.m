//
//  CatalogueDetailsVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 21.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "CatalogueDetailsVC.h"
#import "CatalogueSiteVC.h"

@interface CatalogueDetailsVC ()

@end

@implementation CatalogueDetailsVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = self.currentCatalogue.catalogueName;
    self.descriptionLabel.text = self.currentCatalogue.catalogueDescription;
    self.termsLabel.text = self.currentCatalogue.catalogueTerms;
    self.orderingRulesLabel.text = self.currentCatalogue.catalogueOrderingRules;
    
    dispatch_queue_t logoQueue = dispatch_queue_create("logos queue", NULL);
    
    dispatch_async(logoQueue, ^{
        NSData *imageData = [[NSData alloc] initWithContentsOfURL: [NSURL URLWithString:self.currentCatalogue.catalogueLogoUrl]];
        UIImage *catalogueLogo = [UIImage imageWithData: imageData];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.logoImageView.backgroundColor = [UIColor whiteColor];
            self.logoImageView.image = catalogueLogo;
        });
    });
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"openCatalogue"])
        if ([segue.destinationViewController isKindOfClass:[CatalogueSiteVC class]])
        {
            CatalogueSiteVC *targetVC = segue.destinationViewController;
            targetVC.currentCatalogue = self.currentCatalogue;
        }
}


@end
