//
//  ViewController.h
//  BDPassCodeView
//
//  Created by Bhaskar Jyoti Das on 03/10/17.
//  Copyright © 2017 Bhaskar Jyoti Das. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *passcodeLength;
- (IBAction)didTapEnablePasscode:(id)sender;
- (IBAction)didTapLockPasscode:(id)sender;
- (IBAction)didTapEnterOTP:(id)sender;


@end

