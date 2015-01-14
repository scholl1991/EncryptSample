//
//  DataSource.h
//  EncryptSample
//
//  Created by Serg Shulga on 1/6/15.
//  Copyright (c) 2015 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Message;
@class Stream;
@class User;
@class NSFetchedResultsController;

@interface DataSource : NSObject

+ (instancetype) shared;

- (void) saveContext;
- (void) resetContext;

- (void) fillData;
- (void) clearDatabase;


// synchronous
- (void) addMessage: (NSDictionary*) messageInfo;
- (User*) addUser: (NSDictionary*) userInfo;
// asynchronous (we can use completion block)
- (void) addNewUser;
- (void) addNewUserWithCompletion: (void(^)(NSError* error)) completionBlock;


// Fetching
- (NSArray*) getStreams;
- (NSArray*) getUsers;
- (Message*) getMessageById: (NSString*) messageId;
- (void) getStreamsWithCompletion:(void (^)(NSArray *objects, NSError *error))completion; // it's a background fetching

- (NSFetchedResultsController*) streamsFetchedResultsController;
- (NSFetchedResultsController*) messagesFetchedResultsControllerForStream: (Stream*) stream;

@end
