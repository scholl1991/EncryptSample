//
//  EncryptSampleTests.m
//  EncryptSampleTests
//
//  Created by Serg Shulga on 1/6/15.
//  Copyright (c) 2015 TecSynt. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <XCTest/XCTest.h>

#import "DataSource.h"
#import "User.h"

@interface EncryptSampleTests : XCTestCase

@end

@implementation EncryptSampleTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    XCTAssert(YES, @"Pass");
}

- (void)testNotCachedData
{
    [[DataSource shared] clearDatabase];
    [[DataSource shared] fillData];
    
    for (int i = 0; i < 100; i++)
    {
        User* user = [[DataSource shared] addUser: nil];
        [[DataSource shared] addMessage: @{@"senderId":user.userId}];
    }
    
    [self measureBlock:^{

        for (int i = 0; i < 1000; i++)
        {
            @autoreleasepool
            {
                [[DataSource shared] getStreams];
                [[DataSource shared] getUsers];
                [[DataSource shared] resetContext];
            }
        }
        
    }];
}

- (void) testMemoryData
{
    [[DataSource shared] clearDatabase];
    [[DataSource shared] fillData];
    
    for (int i = 0; i < 100; i++)
    {
        User* user = [[DataSource shared] addUser: nil];
        [[DataSource shared] addMessage: @{@"senderId":user.userId}];
    }
    
    [self measureBlock:^
    {
        for (int i = 0; i < 1000; i++)
        {
            [[DataSource shared] getStreams];
            [[DataSource shared] getUsers];
        }
    }];
}

- (void) testInsertObjects
{
    [[DataSource shared] clearDatabase];
    [[DataSource shared] fillData];
    
    [self measureBlock:^
    {
        for (int i = 0; i < 500; i++)
        {
            User* user = [[DataSource shared] addUser: nil];
            [[DataSource shared] addMessage: @{@"senderId":user.userId}];
        }
    }];
}

@end
