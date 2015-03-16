//
//  MSSQLData.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 20.02.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "MSSQLData.h"

@implementation MSSQLData

- (NSArray *) getCatalogueList
{
    SQLClient* client = [SQLClient sharedInstance];
    client.delegate = self;
    
    __block NSArray *catalogueList = nil;
    
    [client connect:@"win-sql.df-webhosting.de:5433\\SQLEXPRESS" username:@"winweb7db1" password:@"tsp061832" database:@"winweb94db1" completion:^(BOOL success)
    {
        if (success)
        {
            NSLog(@"Connected");
            [client execute:@"select CatalogueName from Catalogues" completion:^(NSArray *results)
            {
                NSLog(@"%@", results);
                catalogueList = results;
            }];
        }
    }];
    return catalogueList;
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
