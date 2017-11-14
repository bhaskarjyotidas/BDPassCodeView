# BDPassCodeView

BDPassCodeView is a Objective C custom passcode lock view and otp enterview. which support 4 digit and 6 digit passcode lock and OTP enter screen.

# Features!
- 4 Digit Passcode Lock.
- 6 Digit Passcode Lock.
- 4 Digit OTP enter screen.
- 6 Digit OTP enter screen.
- Timer feature to auto lock enable.

## ScreenShots

![](https://raw.githubusercontent.com/BhaskarJyotiDas/BDPassCodeView/master/ScreenShots/1.png?raw=true)
![](https://raw.githubusercontent.com/BhaskarJyotiDas/BDPassCodeView/master/ScreenShots/2.png?raw=true)
![](https://raw.githubusercontent.com/BhaskarJyotiDas/BDPassCodeView/master/ScreenShots/3.png?raw=true)
![](https://raw.githubusercontent.com/BhaskarJyotiDas/BDPassCodeView/master/ScreenShots/4.png?raw=true)

# How To Use
## import BDPassCodeView file like
#import "BDPassCodeView.h"
## Set  new Passcode
Set new passcode for first time use this code snippet
[BDPassCodeView setBDPasscodeDelegate:(id)self];
[BDPassCodeView saveApplicationPasscodelength: PasscodeLengthFourDigit];
[BDPassCodeView showPasscodeViewWithType:PassCodeTypeNew];

### OR
To set passcode programmatically use this code snippet
[BDPassCodeView setBDPasscodeDelegate:(id)self];
[BDPassCodeView saveApplicationPasscodelength:PasscodeLengthFourDigit];
[BDPassCodeView saveApplicationPasscode:<Your passcode string>];

## Check for Passcode
[BDPassCodeView showPasscodeViewWithType:PassCodeTypeCheck];
### N.B.
This method check already passcode is set for the app otherwise it will try to set a new passcode. Generally implement this in applicationDidBecomeActive method of AppDelegate. And check there if passcode is set already depending on requirment.

## Force lock application with passcode
To lock application with passcode use this code snippet
[BDPassCodeView resetLastPassCodeEnterTime];
[BDPassCodeView setBDPasscodeDelegate:(id)self];
[BDPassCodeView showPasscodeViewWithType:PassCodeTypeCheck];

## OTP enter screen
To enter OTP use this code snippet
[BDPassCodeView setBDPasscodeDelegate:(id)self];
[BDPassCodeView showPasscodeViewWithType:PassCodeTypeSixDigitOTP];

# Delegate Methods
get notified after setting up new passcode, successfully validate passcode and after OTP enter.
### - (void)_BDPasscodeEnterSuccessfullyCompleteForPassCodeType:(PassCodeType)passcodeType withEnteredValue:(NSString *)enteredValueString
get notified if reset passcode or reset OTP pressed.
### -(void)_BDPasscodeResetPressdForPassCodeType:(PassCodeType)passcodeType



## Author
### Bhaskar Jyoti Das

<bhaskar.bankura@gmail.com>

## License
BDCustomAlert is available under the MIT license. See the LICENSE file for more info.

