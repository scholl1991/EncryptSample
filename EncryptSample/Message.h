//
//  Message.h
//  EncryptSample
//
//  Created by Serg Shulga on 1/7/15.
//  Copyright (c) 2015 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class File, Stream, User;

@interface Message : NSManagedObject

@property (nonatomic, retain) NSString * messageId;
@property (nonatomic, retain) NSDate* date;
@property (nonatomic, retain) File *file;
@property (nonatomic, retain) User *sender;
@property (nonatomic, retain) NSSet *streams;
@property (nonatomic, retain) NSSet *recepients;
@end

@interface Message (CoreDataGeneratedAccessors)

- (void)addStreamsObject:(Stream *)value;
- (void)removeStreamsObject:(Stream *)value;
- (void)addStreams:(NSSet *)values;
- (void)removeStreams:(NSSet *)values;

- (void)addRecepientsObject:(User *)value;
- (void)removeRecepientsObject:(User *)value;
- (void)addRecepients:(NSSet *)values;
- (void)removeRecepients:(NSSet *)values;

@end
