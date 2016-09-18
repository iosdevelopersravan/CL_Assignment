//
//  Constants.h
//  CL_Assignment
//
//  Created by Sravan on 9/18/16.
//  Copyright © 2016 Sravan. All rights reserved.
//

#ifndef Constants_h
#define Constants_h

#ifdef __OBJC__
#import "AppDelegate.h"
#define App_Delegate         ((AppDelegate*)[[UIApplication sharedApplication]delegate])
#endif

#define NSLOCALIZEDSTRING(string)     NSLocalizedString(string, nil)

//************** WebService Parameters *******************
#define KPRODUCTS                            @"products"
#define KPRODUCT_NAME                        @"productname"
#define KPRICE                               @"price"
#define KVENDOR_NAME                         @"vendorname"
#define KVENDOR_ADDRESS                      @"vendoraddress"
#define KPRODUCT_IMG                         @"productImg"
#endif /* Constants_h */


