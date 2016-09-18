//
//  WebServiceCall.h
//  CL_Assignment
//
//  Created by Sravan on 9/18/16.
//  Copyright © 2016 Sravan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Constants.h"

typedef void(^tFailureBlock)(NSInteger responseCode,NSError *error);
typedef void (^tResponseBlock)(NSInteger responseCode,id responseObject);
typedef void (^tFailureResponse)(id responseObject,NSInteger responseCode,NSError *error);

@interface WebServiceCall : NSObject

+(WebServiceCall *)sharedInstance;

-(void)serviceCallWithRequestType:(NSString*)requestTypeString  webServiceUrl:(NSString *)webServiceUrl SuccessfulBlock:(tResponseBlock)successBlock FailedCallBack:(tFailureResponse)failureBlock;

@property(nonatomic,strong) void(^successBlock)(NSDictionary* responseDict);
@property(nonatomic,strong) void(^failureBlock)();

@end
