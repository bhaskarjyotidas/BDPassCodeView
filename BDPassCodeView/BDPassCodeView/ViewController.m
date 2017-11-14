//
//  ViewController.m
//  BDPassCodeView
//
//  Created by Bhaskar Jyoti Das on 03/10/17.
//  Copyright © 2017 Bhaskar Jyoti Das. All rights reserved.
//

#import "ViewController.h"
#import "BDPassCodeView.h"

@interface ViewController () <BDPassCodeDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
//    [BDPassCodeView setBDPasscodeDelegate:(id)self];
//    [BDPassCodeView saveApplicationPasscodelength:PasscodeLengthFourDigit];
//    [BDPassCodeView saveApplicationPasscode:@"1234"];
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
    [BDPassCodeView setBDPasscodeDelegate:(id)self];
    [BDPassCodeView saveApplicationPasscodelength:self.passcodeLength.selectedSegmentIndex == 0 ? PasscodeLengthSixDigit : PasscodeLengthFourDigit];
    [BDPassCodeView showPasscodeViewWithType:PassCodeTypeNew];
}

- (IBAction)didTapLockPasscode:(id)sender {
    [BDPassCodeView resetLastPassCodeEnterTime];
    [BDPassCodeView setBDPasscodeDelegate:(id)self];
    [BDPassCodeView showPasscodeViewWithType:PassCodeTypeCheck];
}

- (IBAction)didTapEnterOTP:(id)sender {
    [BDPassCodeView setBDPasscodeDelegate:(id)self];
    [BDPassCodeView showPasscodeViewWithType:PassCodeTypeSixDigitOTP];
}

@end
