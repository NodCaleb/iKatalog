//
//  AddItemVC.h
//  iKatalog
//
//  Created by Eugene Rozhkov on 07.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Catalogue.h"
#import "OrderItem.h"

@protocol SaveOrderItemProtocol <NSObject>

@required

-(void)rememberCurrentItem:(OrderItem *)currentItem;
-(void)saveCurrentItem:(OrderItem *)currentItem;

@optional

@end

@interface AddItemVC : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSMutableArray *catalogueList;
@property (strong, nonatomic) Catalogue *currentCatalogue;
@property (strong, nonatomic) IBOutlet UIPickerView *cataloguePicker;
@property (strong, nonatomic) IBOutlet UITextField *numberField;
@property (strong, nonatomic) IBOutlet UITextField *nameField;
@property (strong, nonatomic) IBOutlet UITextField *priceField;
@property (strong, nonatomic) IBOutlet UITextField *sizeField;
@property (strong, nonatomic) IBOutlet UITextField *colorField;
@property (strong, nonatomic) IBOutlet UIButton *addButton;
@property (strong, nonatomic) OrderItem *currentOrderItem;
@property (weak, nonatomic) id <SaveOrderItemProtocol> delegate;

- (IBAction)addItemPressed:(UIButton *)sender;

@end
