//
//  ViewController.m
//  BDPassCodeView
//
//  Created by Bhaskar Jyoti Das on 03/10/17.
//  Copyright © 2017 Bhaskar Jyoti Das. All rights reserved.
//

#import "ViewController.h"
#import "BDPassCode.h"

@interface ViewController () <BDPassCodeDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)_BDPasscodeResetPressdForPassCodeType:(PassCodeType)passcodeType
{
    NSLog(@"Reset Passcode%ld",passcodeType);
}

- (void)_BDPasscodeEnterSuccessfullyCompleteForPassCodeType:(PassCodeType)passcodeType withEnteredValue:(NSString *)enteredValueString
{
    NSLog(@"Reset Passcode %ld value %@", passcodeType, enteredValueString);
}

- (IBAction)didTapEnablePasscode:(id)sender {
    [BDPassCode setBDPasscodeDelegate:(id)self];
    [BDPassCode saveApplicationPasscodelength:self.passcodeLength.selectedSegmentIndex == 0 ? PasscodeLengthSixDigit : PasscodeLengthFourDigit];
    [BDPassCode showPasscodeViewWithType:PassCodeTypeNew];
}

- (IBAction)didTapLockPasscode:(id)sender {
    [BDPassCode resetLastPassCodeEnterTime];
    [BDPassCode setBDPasscodeDelegate:(id)self];
    [BDPassCode showPasscodeViewWithType:PassCodeTypeCheck];
}

- (IBAction)didTapEnterOTP:(id)sender {
    [BDPassCode setBDPasscodeDelegate:(id)self];
    [BDPassCode showPasscodeViewWithType:PassCodeTypeOTP];
}

@end
