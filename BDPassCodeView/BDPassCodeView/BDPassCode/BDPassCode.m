//
//  BDPassCode.m
//  BDPassCodeView
//
//  Created by Bhaskar Jyoti Das on 03/10/17.
//  Copyright © 2017 Bhaskar Jyoti Das. All rights reserved.
//

#import "BDPassCode.h"
#define kApplicationPasscodeLength @"kApplicationPasscodeLength"
#define kApplicationPasscode @"kApplicationPasscode"
#define kDefaultPasscodeEnterTime 30.0

@interface MyRootViewController : UIViewController
@end

@implementation MyRootViewController

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

@end

@implementation BDPassCodeButton

- (void)setHighlighted:(BOOL)highlighted {
    [super setHighlighted:highlighted];
    UIView *superView = [self superview];
    BDGlowLabel *label = [superView viewWithTag:100 + [self tag]];
    if (highlighted) {
        label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.5];
    }else{
        label.backgroundColor = [UIColor colorWithWhite:1 alpha:0.1];
    }
    
}

@end

@implementation BDGlowLabel

- (void)layoutSubviews
{
    [super layoutSubviews];
    self.layer.cornerRadius = self.frame.size.height / 2;
    self.layer.borderWidth = 1;
    self.layer.borderColor = [UIColor whiteColor].CGColor;
    self.clipsToBounds = YES;
    self.layer.shadowColor = [self.glowColor ? self.glowColor : [UIColor blackColor]  CGColor];
    self.layer.shadowRadius = 2.0f;
    self.layer.shadowOpacity = .6;
    self.layer.shadowOffset = CGSizeZero;
    //    self.layer.masksToBounds = NO;
}

@end


@interface BDPassCode ()
@property NSTimeInterval lastPasscodeEnterTime;
@property (weak, nonatomic) IBOutlet BDGlowLabel *pinOneView;
@property (weak, nonatomic) IBOutlet BDGlowLabel *pinSixView;
@property (assign, nonatomic) id <BDPassCodeDelegate> delegate;
@property (weak, nonatomic) IBOutlet UIView *passcodeContainerView;
@property (nonatomic, strong) NSString *enteredPassCode;
@property (nonatomic, strong) NSString *applicationPassCode;
@property (nonatomic, strong) NSString *flagNewPassCode;
@property (nonatomic, strong) NSString *flagPreviousPassCode;
@property (nonatomic, strong) NSString *enterOTPText;
@property PassCodeType currentPasscodeType;
@property PasscodeLength currentPasscodeLength;
@property (strong, nonatomic) UIWindow *window;
@property (weak, nonatomic) IBOutlet UILabel *informationLabel;
@property (weak, nonatomic) IBOutlet UIButton *resetButton;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (strong, nonatomic) IBOutletCollection(BDGlowLabel) NSArray *enterPasscodeLabels;
- (IBAction)didTapEnterPassCode:(id)sender;
- (IBAction)didTapResetButton:(id)sender;
- (IBAction)didTapCancelButton:(id)sender;

@end

@implementation BDPassCode
static BDPassCode *sharedMyManager = nil;

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void)showView : (UIView *)view withAnimation : (BOOL)isAnimation
{
    UIWindow *window = [[UIApplication sharedApplication] keyWindow];
    if (!window) {
        window = [[[UIApplication sharedApplication] delegate] window];
    }
    self.frame = window.frame;
    self.center = window.center;
    [window addSubview:self];
    if (!self.window) {
        self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
        self.window.restorationIdentifier = @"BDPassCodeWindow";
        self.window.backgroundColor = [UIColor clearColor];
        self.window.windowLevel = UIWindowLevelAlert + 1;
        self.window.rootViewController = [[MyRootViewController alloc]init];
    }
    self.window.frame = [[UIScreen mainScreen] bounds];
    [self.window makeKeyAndVisible];
    if (isAnimation) {
        CABasicAnimation *scaleAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
        scaleAnimation.duration = 0.2;
        scaleAnimation.repeatCount = 0;
        scaleAnimation.autoreverses = NO;
        scaleAnimation.fromValue = [NSNumber numberWithFloat:0.2];
        scaleAnimation.toValue = [NSNumber numberWithFloat:1.0];
        [view.layer addAnimation:scaleAnimation forKey:@"scale"];
    }
    
    [self.window addSubview:self];
}

- (void)dismiss
{
    self.window = nil;
    [self removeFromSuperview];
}

- (instancetype)init
{
    NSBundle *bundle = [NSBundle mainBundle];
    self = [[bundle loadNibNamed:@"BDPassCode" owner:self options:nil] objectAtIndex:0];
    if (self) {
    }
    return self;
}

+ (id)sharedManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedMyManager = [[self alloc] init];
    });
    return sharedMyManager;
}

+ (void)setBDPasscodeDelegate:(id)delegate
{
    if (!sharedMyManager) {
        [self sharedManager];
    }
    sharedMyManager.delegate = delegate;
}

+ (NSString *)getPassCode
{
    return [[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPasscode];
}

+ (NSString *)getOTP
{
    return sharedMyManager.enterOTPText;
}

+ (PasscodeLength)getPassCodeLength
{
    return [[[NSUserDefaults standardUserDefaults] objectForKey:kApplicationPasscodeLength] integerValue];
}

+ (void)resetApplicationPassCode
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:0] forKey:kApplicationPasscodeLength];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)resetLastPassCodeEnterTime
{
    if (!sharedMyManager) {
        [self sharedManager];
    }
    sharedMyManager.lastPasscodeEnterTime = 0;
}

- (void)reloadPassCodeLength
{
    self.currentPasscodeLength = [[[NSUserDefaults standardUserDefaults] objectForKey:kApplicationPasscodeLength] integerValue];
    if (self.currentPasscodeLength < PasscodeLengthFourDigit) {
        self.currentPasscodeLength = PasscodeLengthSixDigit;
        [BDPassCode saveApplicationPasscodelength:PasscodeLengthSixDigit];
    }
    if (self.currentPasscodeLength == PasscodeLengthFourDigit) {
        self.pinOneView.hidden = YES;
        self.pinSixView.hidden = YES;
    }
    else{
        self.pinOneView.hidden = NO;
        self.pinSixView.hidden = NO;
    }
    self.applicationPassCode = [[NSUserDefaults standardUserDefaults] valueForKey:kApplicationPasscode];
}

+ (void)saveApplicationPasscodelength:(PasscodeLength)length
{
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInteger:length] forKey:kApplicationPasscodeLength];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (void)saveApplicationPasscode:(NSString *)passcode
{
    if (passcode.length == PasscodeLengthFourDigit || passcode.length == PasscodeLengthSixDigit) {
        [BDPassCode saveApplicationPasscodelength:passcode.length];
        [[NSUserDefaults standardUserDefaults] setValue:passcode forKey:kApplicationPasscode];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
}

+ (void)showPasscodeViewWithType:(PassCodeType)type
{
    if (!sharedMyManager) {
        [self sharedManager];
    }
    [sharedMyManager resetView];
    [sharedMyManager reloadPassCodeLength];
    sharedMyManager.enteredPassCode = @"";
    sharedMyManager.enterOTPText = @"";
    sharedMyManager.currentPasscodeType = type;
    [sharedMyManager.resetButton setTitle:@"Reset Passcode" forState:UIControlStateNormal];
    switch (type) {
        case PassCodeTypeNew:
        {
            sharedMyManager.flagPreviousPassCode = [BDPassCode getPassCode];
            [BDPassCode resetApplicationPassCode];
            sharedMyManager.lastPasscodeEnterTime = 0;
            sharedMyManager.flagNewPassCode = @"";
            sharedMyManager.informationLabel.text = kNewPasscodeEnterText;
            sharedMyManager.resetButton.hidden = YES;
            sharedMyManager.cancelButton.hidden = NO;
        }
            break;
        case PassCodeTypeReEnter:
        {
            sharedMyManager.lastPasscodeEnterTime = 0;
            sharedMyManager.informationLabel.text = kReenterPasscodeText;
            sharedMyManager.resetButton.hidden = NO;
            sharedMyManager.cancelButton.hidden = YES;
        }
            break;
        case PassCodeTypeCheck:
        {
            NSTimeInterval currenttime = [[NSDate date] timeIntervalSince1970];
            if ((currenttime - sharedMyManager.lastPasscodeEnterTime) < kDefaultPasscodeEnterTime) {
                return;
            }
            sharedMyManager.lastPasscodeEnterTime = 0;
            if (sharedMyManager.applicationPassCode.length == PasscodeLengthFourDigit || sharedMyManager.applicationPassCode.length == PasscodeLengthSixDigit) {
                sharedMyManager.informationLabel.text = kEnterPasscodeText;
                sharedMyManager.resetButton.hidden = NO;
                sharedMyManager.cancelButton.hidden = YES;
            }
            else{
                [BDPassCode showPasscodeViewWithType:PassCodeTypeNew];
                return;
            }
        }
            break;
        case PassCodeTypeOTP:
        {
            [sharedMyManager.resetButton setTitle:@"Resend OTP" forState:UIControlStateNormal];
            sharedMyManager.informationLabel.text = kEnterOTPText;
            sharedMyManager.resetButton.hidden = NO;
            sharedMyManager.cancelButton.hidden = NO;
        }
            break;
            
        default:
            break;
    }
    [sharedMyManager showView:nil withAnimation:YES];
}

- (IBAction)didTapEnterPassCode:(id)sender {
    NSInteger tappedPin = [sender tag];
    if (tappedPin == 11 && self.enteredPassCode.length > 0)
    {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.tag == %ld", self.currentPasscodeLength == PasscodeLengthSixDigit ? self.enteredPassCode.length : (self.enteredPassCode.length + 1)];
        self.enteredPassCode = [self.enteredPassCode substringToIndex:[self.enteredPassCode length]-1];
        NSArray *arr = [self.enterPasscodeLabels filteredArrayUsingPredicate:predicate];
        if (arr.count > 0) {
            [self editPassCodeField:[arr firstObject] withStateSelected:NO];
        }
    }
    else if (tappedPin != 11)
    {
        if (self.enteredPassCode.length < self.currentPasscodeLength) {
            self.enteredPassCode = [self.enteredPassCode stringByAppendingString:[NSString stringWithFormat:@"%ld", tappedPin]];
            NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self.tag == %ld", self.currentPasscodeLength == PasscodeLengthSixDigit ? self.enteredPassCode.length : (self.enteredPassCode.length + 1)];
            NSArray *arr = [self.enterPasscodeLabels filteredArrayUsingPredicate:predicate];
            if (arr.count > 0) {
                [self editPassCodeField:[arr firstObject] withStateSelected:YES];
            }
        }
        if (self.enteredPassCode.length == self.currentPasscodeLength) {
            [self validatePasscode];
        }
    }
    
}

- (IBAction)didTapResetButton:(id)sender {
    PassCodeType type = self.currentPasscodeType;
    switch (self.currentPasscodeType) {
        case PassCodeTypeReEnter:
        {
            self.currentPasscodeType = PassCodeTypeNew;
            self.flagNewPassCode = @"";
            self.informationLabel.text = kNewPasscodeEnterText;
            self.resetButton.hidden = YES;
            self.cancelButton.hidden = NO;
            [self passcodeViewAnimation];
            return;
        }
            break;
        case PassCodeTypeCheck:
        {
            self.flagPreviousPassCode = [BDPassCode getPassCode];
            self.currentPasscodeType = PassCodeTypeNew;
            self.flagNewPassCode = @"";
            self.informationLabel.text = kNewPasscodeEnterText;
            self.resetButton.hidden = YES;
            self.cancelButton.hidden = NO;
            [self passcodeViewAnimation];
        }
            break;
        case PassCodeTypeOTP:
        {
            [self passcodeViewAnimation];
        }
            break;
            
        default:
            break;
    }
    if ([self.delegate respondsToSelector:@selector(_BDPasscodeResetPressdForPassCodeType:)]) {
        [self.delegate _BDPasscodeResetPressdForPassCodeType:type];
    }
}

- (IBAction)didTapCancelButton:(id)sender {
    if (self.currentPasscodeType == PassCodeTypeNew) {
        [BDPassCode saveApplicationPasscode:self.flagPreviousPassCode];
    }
    [self dismiss];
}

- (void)editPassCodeField : (BDGlowLabel *)passCodeLabel withStateSelected : (BOOL)isSelected
{
    [passCodeLabel setBackgroundColor:[UIColor colorWithWhite:1 alpha:isSelected ? 1.0 : 0.1]];
}

- (void)validatePasscode
{
    switch (self.currentPasscodeType) {
        case PassCodeTypeNew:
        {
            self.currentPasscodeType = PassCodeTypeReEnter;
            self.informationLabel.text = kReenterPasscodeText;
            self.resetButton.hidden = NO;
            self.cancelButton.hidden = YES;
            self.flagNewPassCode = self.enteredPassCode;
            [self passcodeViewAnimation];
        }
            break;
        case PassCodeTypeReEnter:
        {
            if ([self.flagNewPassCode isEqualToString:self.enteredPassCode])
            {
                [BDPassCode saveApplicationPasscode:self.enteredPassCode];
                [self dismiss];
                if ([self.delegate respondsToSelector:@selector(_BDPasscodeEnterSuccessfullyCompleteForPassCodeType:withEnteredValue:)]) {
                    [self.delegate _BDPasscodeEnterSuccessfullyCompleteForPassCodeType:self.currentPasscodeType withEnteredValue:self.enteredPassCode];
                }
            }
            else {
                [self passcodeViewAnimation];
            }
        }
            break;
        case PassCodeTypeCheck:
        {
            if ([self.applicationPassCode isEqualToString:self.enteredPassCode])
            {
                if ([self.delegate respondsToSelector:@selector(_BDPasscodeEnterSuccessfullyCompleteForPassCodeType:withEnteredValue:)]) {
                    [self.delegate _BDPasscodeEnterSuccessfullyCompleteForPassCodeType:self.currentPasscodeType withEnteredValue:self.enteredPassCode];
                }
                self.lastPasscodeEnterTime = [[NSDate date] timeIntervalSince1970];
                [self dismiss];
            }
            else
            {
                [self passcodeViewAnimation];
            }
        }
            break;
        case PassCodeTypeOTP:
        {
            self.enterOTPText = self.enteredPassCode;
            if ([self.delegate respondsToSelector:@selector(_BDPasscodeEnterSuccessfullyCompleteForPassCodeType:withEnteredValue:)]) {
                [self.delegate _BDPasscodeEnterSuccessfullyCompleteForPassCodeType:self.currentPasscodeType withEnteredValue:self.enteredPassCode];
            }
            [self dismiss];
        }
            break;
            
        default:
            break;
    }
}

- (void)resetView
{
    self.enteredPassCode = @"";
    for (BDGlowLabel *label in self.enterPasscodeLabels) {
        [self editPassCodeField:label withStateSelected:NO];
    }
}

- (void)passcodeViewAnimation
{
    CABasicAnimation *animation = [CABasicAnimation animationWithKeyPath:@"position"];
    animation.delegate = (id)self;
    [animation setDuration:0.09];
    [animation setRepeatCount:2];
    [animation setAutoreverses:YES];
    [animation setFromValue:[NSValue valueWithCGPoint:
                             CGPointMake([self.passcodeContainerView center].x - 20.0f, [self.passcodeContainerView center].y)]];
    [animation setToValue:[NSValue valueWithCGPoint:
                           CGPointMake([self.passcodeContainerView center].x + 20.0f, [self.passcodeContainerView center].y)]];
    [self.passcodeContainerView.layer addAnimation:animation forKey:@"position"];
}

- (void)animationDidStop:(CAAnimation *)anim finished:(BOOL)flag
{
    [self resetView];
}

@end
