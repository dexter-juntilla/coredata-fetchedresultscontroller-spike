//
//  Item+CoreDataProperties.h
//  CoreDataListenerSpike
//
//  Created by DNA on 9/1/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Item.h"

NS_ASSUME_NONNULL_BEGIN

@interface Item (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *title;
@property (nullable, nonatomic, retain) NSNumber *done;
@property (nullable, nonatomic, retain) NSDate *createdDate;

@end

NS_ASSUME_NONNULL_END
