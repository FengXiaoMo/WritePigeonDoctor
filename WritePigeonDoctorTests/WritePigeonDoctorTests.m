//
//  WritePigeonDoctorTests.m
//  WritePigeonDoctorTests
//
//  Created by zhongyu on 16/7/11.
//  Copyright © 2016年 RyeWhiskey. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "RWRequsetManager+UserLogin.h"

@interface WritePigeonDoctorTests : XCTestCase

@end

@implementation WritePigeonDoctorTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)testRegister
{
    RWRequsetManager *manager = [[RWRequsetManager alloc] init];
    
    [manager registerWithUsername:@"iOSTest002"
                      AndPassword:@"iOSTest002"
                 verificationCode:@""];
    
    
//    [manager userinfoWithUsername:@"12345678121" AndPassword:@"123"];
    
    CFRunLoopRun();
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
