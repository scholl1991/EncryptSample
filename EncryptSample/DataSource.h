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
- (User*) addUser: (NSDictionary*) userInfo __deprecated_msg("use addNewUser instead");
// asynchronous (we can use completion block)
- (void) addNewUser;


// Fetching
- (NSArray*) getStreams;
- (NSArray*) getUsers;
- (Message*) getMessageById: (NSString*) messageId;

- (NSFetchedResultsController*) streamsFetchedResultsController;
- (NSFetchedResultsController*) messagesFetchedResultsControllerForStream: (Stream*) stream;

@end
