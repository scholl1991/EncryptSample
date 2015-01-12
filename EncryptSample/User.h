//
//  User.h
//  EncryptSample
//
//  Created by Serg Shulga on 1/7/15.
//  Copyright (c) 2015 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message, Stream;

@interface User : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSSet *outgoingMessages;
@property (nonatomic, retain) Stream *stream;
@property (nonatomic, retain) NSSet *receivedMessages;
@end

@interface User (CoreDataGeneratedAccessors)

- (void)addOutgoingMessagesObject:(Message *)value;
- (void)removeOutgoingMessagesObject:(Message *)value;
- (void)addOutgoingMessages:(NSSet *)values;
- (void)removeOutgoingMessages:(NSSet *)values;

- (void)addReceivedMessagesObject:(Message *)value;
- (void)removeReceivedMessagesObject:(Message *)value;
- (void)addReceivedMessages:(NSSet *)values;
- (void)removeReceivedMessages:(NSSet *)values;

@end
