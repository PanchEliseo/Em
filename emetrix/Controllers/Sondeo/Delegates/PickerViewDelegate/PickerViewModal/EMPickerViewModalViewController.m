//
//  EMPickerViewModalViewController.m
//  emetrix
//
//  Created by Carlos molina on 15/09/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMPickerViewModalViewController.h"
#import "EMSondeoPickerViewDelegate.h"

@interface EMPickerViewModalViewController ()
@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (strong, nonatomic) EMSondeoPickerViewDelegate * pickerViewDelegate;

@end

@implementation EMPickerViewModalViewController

- (EMSondeoPickerViewDelegate *) pickerViewDelegate
{
    if(!_pickerViewDelegate)
    {
        _pickerViewDelegate = [[EMSondeoPickerViewDelegate alloc] init];
    }
    return _pickerViewDelegate;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.pickerView.tag = self.index;
    self.pickerView.delegate = self.pickerViewDelegate;
    self.pickerView.dataSource = self.pickerViewDelegate;
    self.pickerViewDelegate.pull = self.pull;
    self.pickerViewDelegate.preguntas = self.preguntas;
    [self.pickerViewDelegate selectQuestion:self.pickerView];
    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.pickerView reloadAllComponents];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)didPressSelect:(UIBarButtonItem *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)didPressCancel:(id)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
