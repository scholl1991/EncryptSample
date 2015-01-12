//
//  Stream.h
//  EncryptSample
//
//  Created by Serg Shulga on 1/7/15.
//  Copyright (c) 2015 TecSynt. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Message, User;

@interface Stream : NSManagedObject

@property (nonatomic, retain) NSString * streamId;
@property (nonatomic, retain) NSSet *messages;
@property (nonatomic, retain) User *user;
@end

@interface Stream (CoreDataGeneratedAccessors)

- (void)addMessagesObject:(Message *)value;
- (void)removeMessagesObject:(Message *)value;
- (void)addMessages:(NSSet *)values;
- (void)removeMessages:(NSSet *)values;

@end
