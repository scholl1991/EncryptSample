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
    
    [[DataSource shared] clearDatabase];
    [[DataSource shared] fillData];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testMultithreading
{
//    XCTAssert(YES, @"Pass");
//    XCTAssertTrue(YES, "saveToURL failed");
    
//    for (int i = 0; i < 100; i++)
//    {
//        User* user = [[DataSource shared] addUser: nil];
//        [[DataSource shared] addMessage: @{@"senderId":user.userId}];
//    }
    
    for (int i = 0; i < 100; i++)
    {
        XCTestExpectation* expectation = [self expectationWithDescription: [NSString stringWithFormat:@"com.tecsynt.multithreading%d", i]];
        XCTestExpectation* fetchExpectation = [self expectationWithDescription: [NSString stringWithFormat:@"com.tecsynt.multithreading%d", i+1000]];
        [[DataSource shared] addNewUserWithCompletion:^(NSError *error)
        {
            NSLog(@"added");
            [expectation fulfill];
        }];
        [[DataSource shared] getStreamsWithCompletion:^(NSArray *objects, NSError *error)
        {
            NSLog(@"objects.count = %d", objects.count);
            [fetchExpectation fulfill];
        }];
    }
    
    [self waitForExpectationsWithTimeout: 30.0 handler:^(NSError *error) {
        XCTAssertNil(error, @"Bad day");
    }];
}

- (void) startFetching
{
    for (int i = 0; i < 10; i++)
    {
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            NSArray* streams = [[DataSource shared] getStreams];
            NSArray* users = [[DataSource shared] getUsers];
            NSLog(@"streams.count = %d, users.count = %d", streams.count, users.count);
        });
    }
}

- (void)testNotCachedData
{
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
                NSArray* arr1 = [[DataSource shared] getStreams];
                NSArray* arr2 = [[DataSource shared] getUsers];
//                NSLog(@"arr1.count = %d, arr2.count = %d", arr1.count, arr2.count);
                [[DataSource shared] resetContext];
            }
        }
        
    }];
}

- (void) testMemoryData
{
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
