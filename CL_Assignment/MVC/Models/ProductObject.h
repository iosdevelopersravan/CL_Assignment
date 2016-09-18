//
//  ProductObject.h
//  CL_Assignment
//
//  Created by Sravan on 9/18/16.
//  Copyright © 2016 Sravan. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ProductObject : NSObject
@property(nonatomic,strong)NSString *productnameString;
@property(nonatomic,strong)NSString *priceString;
@property(nonatomic,strong)NSString *vendornameString;
@property(nonatomic,strong)NSString *vendoraddressString;
@property(nonatomic,strong)NSString *productImageUrlString;
@property(nonatomic,strong)NSString *phoneNumberString;
@property(nonatomic,readwrite)BOOL isProductAdded;
@end
