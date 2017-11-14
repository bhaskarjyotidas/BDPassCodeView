//
//  BDPassCodeViewUITests.m
//  BDPassCodeViewUITests
//
//  Created by Bhaskar Jyoti Das on 03/10/17.
//  Copyright © 2017 Bhaskar Jyoti Das. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface BDPassCodeViewUITests : XCTestCase

@end

@implementation BDPassCodeViewUITests

- (void)setUp {
    [super setUp];
    
    // Put setup code here. This method is called before the invocation of each test method in the class.
    
    // In UI tests it is usually best to stop immediately when a failure occurs.
    self.continueAfterFailure = NO;
    // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
     [[[XCUIApplication alloc] init] launch];
    
    // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // Use recording to get started writing UI tests.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    XCUIApplication *app = [[XCUIApplication alloc] init];
    XCUIElement *element = [[[app.otherElements containingType:XCUIElementTypeStaticText identifier:@"Enter passcode"] childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:2];
    
    [[[[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:0] childrenMatchingType:XCUIElementTypeButton].element tap];
    [[[[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:1] childrenMatchingType:XCUIElementTypeButton].element tap];
    [[[[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:2] childrenMatchingType:XCUIElementTypeButton].element tap];
    [[[[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:9] childrenMatchingType:XCUIElementTypeButton].element tap];
    [element tap];
    [[[[element childrenMatchingType:XCUIElementTypeOther] elementBoundByIndex:10] childrenMatchingType:XCUIElementTypeButton].element tap];
    [app.buttons[@"Reset Passcode"] tap];
    [app.buttons[@"               Cancel"] tap];
}

@end
