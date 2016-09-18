//
//  Cart+CoreDataProperties.h
//  CL_Assignment
//
//  Created by Sravan on 9/19/16.
//  Copyright © 2016 Sravan. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "Cart.h"

NS_ASSUME_NONNULL_BEGIN

@interface Cart (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *phoneNumber;
@property (nullable, nonatomic, retain) NSNumber *price;
@property (nullable, nonatomic, retain) NSString *productImage;
@property (nullable, nonatomic, retain) NSString *productname;
@property (nullable, nonatomic, retain) NSString *vendorAddress;
@property (nullable, nonatomic, retain) NSString *vendorName;

@end

NS_ASSUME_NONNULL_END
