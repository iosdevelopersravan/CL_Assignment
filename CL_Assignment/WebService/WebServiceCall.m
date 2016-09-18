//
//  WebServiceCall.m
//  CL_Assignment
//
//  Created by Sravan on 9/18/16.
//  Copyright © 2016 Sravan. All rights reserved.
//

#import "WebServiceCall.h"
@implementation WebServiceCall

+(WebServiceCall *)sharedInstance{
    
    static WebServiceCall *sharedInstance;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [WebServiceCall new];
    });
    return sharedInstance;
}


-(void)serviceCallWithRequestType:(NSString*)requestTypeString  webServiceUrl:(NSString *)webServiceUrl SuccessfulBlock:(tResponseBlock)successBlock FailedCallBack:(tFailureResponse)failureBlock {

    NSURL *url = [NSURL URLWithString:webServiceUrl];
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration delegate:nil delegateQueue:nil];

    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url
                                                           cachePolicy:NSURLRequestUseProtocolCachePolicy
                                                       timeoutInterval:60.0];
    
    [request addValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
    
    [request setHTTPMethod:requestTypeString];

    NSLog(@"\n=====================Request=================================\nURL String : %@\n=========================End Request=============================",request.URL.absoluteString);
    NSLog(@"Request Header--->%@",request.allHTTPHeaderFields);
    
    NSURLSessionDataTask *postDataTask = [session dataTaskWithRequest:request completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
        
        if (!error){
            
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            if (statusCode != 200 && statusCode != 201) {
                NSLog(@"dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
                failureBlock(nil,statusCode,error);
            }
            else{
                NSLog(@"request.URL.absoluteString-->%@",request.URL.absoluteString);
                NSString * stringJson = [[NSString alloc] initWithData: data encoding: NSUTF8StringEncoding];
                successBlock([@"200" intValue],stringJson);
            }
        }
        else{
            NSLog(@" %@ FAILURE Description--> %@",webServiceUrl,error.description);
            NSInteger statusCode = [(NSHTTPURLResponse *)response statusCode];
            NSLog(@"FAILURE dataTaskWithRequest HTTP status code: %ld", (long)statusCode);
            failureBlock(nil,statusCode,error);
        }
    }];
    [postDataTask resume];
}


@end

