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
@class NSFetchedResultsController;

@interface DataSource : NSObject

+ (instancetype) shared;

- (void) saveContext;
- (void) resetContext;

- (void) fillData;
- (void) clearDatabase;

- (void) addMessage: (NSDictionary*) messageInfo;
- (void) addUser: (NSDictionary*) userInfo;


// Fetching
- (NSArray*) getStreams;
- (NSArray*) getUsers;
- (Message*) getMessageById: (NSString*) messageId;

- (NSFetchedResultsController*) streamsFetchedResultsController;
- (NSFetchedResultsController*) messagesFetchedResultsControllerForStream: (Stream*) stream;

@end
