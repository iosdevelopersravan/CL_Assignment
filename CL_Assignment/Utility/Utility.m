//
//  Utility.m
//  CL_Assignment
//
//  Created by Sravan on 9/18/16.
//  Copyright © 2016 Sravan. All rights reserved.
//

#import "Utility.h"

@implementation Utility


+(NSDictionary*) dictionaryFromJSON:(NSString*)jsonString
{
    NSDictionary * resultDictionary = nil;
    
    @try {
        if (jsonString == nil)
            return nil;
        
        NSData *jsonData = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
        NSError * error = nil;
        resultDictionary = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:&error];
        
        return resultDictionary;
    }
    @catch (NSException *exception) {
        NSLog(@"Parsing Exception --> %@", [exception description]);
        resultDictionary = [[NSDictionary alloc] init];
    }
    @finally
    {
        return resultDictionary;
    }
}

@end



