//
//  paymentPickerVC.m
//  iKatalog
//
//  Created by Eugene Rozhkov on 12.06.15.
//  Copyright (c) 2015 Nord Point. All rights reserved.
//

#import "paymentPickerVC.h"

@interface paymentPickerVC ()

@end

@implementation paymentPickerVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark — Picker

-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (component == 0) return [self.deliveryMethods count];
    else return 0;
}

-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return [self.deliveryMethods objectAtIndex:row];
}
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (row == 1)
    {
        self.addressHeader.hidden = NO;
        self.addressContent.hidden = NO;
    }
    else
    {
        self.addressHeader.hidden = YES;
        self.addressContent.hidden = YES;
    }
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
