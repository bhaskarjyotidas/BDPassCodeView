//
//  BDPassCode.h
//  BDPassCodeView
//
//  Created by Bhaskar Jyoti Das on 03/10/17.
//  Copyright © 2017 Bhaskar Jyoti Das. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kEnterPasscodeText @"Enter passcode"
#define kEnterOTPText @"Enter your OTP here"
#define kNewPasscodeEnterText @"Enter new passcode here"
#define kReenterPasscodeText @"Re-enter passcode here"

typedef NS_ENUM(NSInteger, PasscodeLength){
    PasscodeLengthFourDigit = 4,
    PasscodeLengthSixDigit = 6,
};

typedef NS_ENUM(NSInteger, PassCodeType){
    PassCodeTypeNew = 0,
    PassCodeTypeReEnter = 1,
    PassCodeTypeCheck = 2,
    PassCodeTypeOTP = 3,
};

@protocol BDPassCodeDelegate <NSObject>
- (void)_BDPasscodeResetPressdForPassCodeType:(PassCodeType)passcodeType;
- (void)_BDPasscodeEnterSuccessfullyCompleteForPassCodeType:(PassCodeType)passcodeType withEnteredValue:(NSString *)enteredValueString;
@end


@interface BDPassCodeButton : UIButton
@end

@interface BDGlowLabel : UILabel
@property (copy, nonatomic) IBInspectable UIColor *glowColor;
@end


@interface BDPassCode : UIView
+ (void)showPasscodeViewWithType:(PassCodeType)type;
+ (void)setBDPasscodeDelegate:(id)delegate;
+ (void)saveApplicationPasscodelength:(PasscodeLength)length;
+ (void)saveApplicationPasscode:(NSString *)passcode;
+ (void)resetApplicationPassCode;
+ (void)resetLastPassCodeEnterTime;
+ (NSString *)getPassCode;
+ (NSString *)getOTP;
+ (PasscodeLength)getPassCodeLength;
@end
