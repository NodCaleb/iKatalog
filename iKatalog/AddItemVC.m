//
//  AddItemVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 07.03.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "AddItemVC.h"
#import "CatalogueSiteVC.h"

@interface AddItemVC ()

@property (nonatomic) BOOL saved;

@end

@implementation AddItemVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.cataloguePicker.delegate = self;
    if (self.currentCatalogue) [self.cataloguePicker selectRow:[self.catalogueList indexOfObject:self.currentCatalogue] inComponent:0 animated:NO];
    if (self.currentOrderItem) [self fillForm];
    self.saved = NO;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

/*
// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
-(void) viewWillDisappear:(BOOL)animated
{
    if (!self.saved)
    {
        OrderItem *currentOrderItem = [[OrderItem alloc] initWithCatalogue:self.currentCatalogue.catalogue_id number:self.numberField.text name:self.nameField.text price:[self.priceField.text floatValue] size:self.sizeField.text andColor:self.colorField.text];
        
        [self.delegate rememberCurrentItem:currentOrderItem];
    }
    
    [super viewWillDisappear:animated];
}

- (IBAction)addItemPressed:(UIButton *)sender
{
    if ([self.numberField.text isEqualToString:@""]||[self.nameField.text isEqualToString:@""]||[self.priceField.text isEqualToString:@""])
    {
        UIAlertView *formAlert = [[UIAlertView alloc] initWithTitle:@"Ошибка!" message:@"Пожалуйста заполните номер артикула, наименование и цену." delegate:nil cancelButtonTitle:@"ОК" otherButtonTitles: nil];
        [formAlert show];
        return;
    }
    
    OrderItem *currentOrderItem = [[OrderItem alloc] initWithCatalogue:self.currentCatalogue.catalogue_id number:self.numberField.text name:self.nameField.text price:[self.priceField.text floatValue] size:self.sizeField.text andColor:self.colorField.text];
    
    self.saved = YES;
    
    [self.delegate saveCurrentItem:currentOrderItem];
    
}

#pragma mark — UIPickerView methods

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.catalogueList count];
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    Catalogue *listItemCatalogue = [self.catalogueList objectAtIndex:row];
    return listItemCatalogue.catalogueName;
}

-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.currentCatalogue = [self.catalogueList objectAtIndex:row];
}

#pragma mark — Helper methods

-(void)fillForm
{
    self.numberField.text = self.currentOrderItem.number;
    self.nameField.text = self.currentOrderItem.name;
    self.priceField.text = [NSString stringWithFormat:@"%.02f",self.currentOrderItem.price];
    self.sizeField.text = self.currentOrderItem.size;
    self.colorField.text = self.currentOrderItem.color;
}

-(void)clearForm
{
    self.numberField.text = @"";
    self.nameField.text = @"";
    self.priceField.text = @"";
    self.sizeField.text = @"";
    self.colorField.text = @"";
    
}

@end
