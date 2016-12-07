//
//  AMSwizzler.m
//  SwizzlingDemo
//
//  Created by Mahesh Kokate on 25/06/16.
//  Copyright © 2016 Mahesh Kokate. All rights reserved.
//

#import "AMSwizzler.h"
#import <objc/runtime.h>

@implementation AMSwizzler


- (void)swizzleMethods
{
    // Get data from server
    [self getDataFromServer];
    
    // [self getLocalData];
}

- (void)getDataFromServer
{
    NSURLSession *session = [NSURLSession sharedSession];
    
    [[session dataTaskWithURL:[NSURL URLWithString:@"https://demo6807390.mockable.io/getData"]
            completionHandler:^(NSData *data,NSURLResponse *response,NSError *error)
      {
          // Received response
          NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&error];
          
          if ([jsonArray isKindOfClass:[NSArray class]])
          {
              for (NSDictionary *dictionary in jsonArray)
              {
                  // Found method details, pass it further for processing
                  [self swizzleMethod:dictionary[@"methodName"] ofClass:dictionary[@"className"] byMethodType:[dictionary[@"methodType"] integerValue]];
              }
          }
      }] resume];
}


- (void)getLocalData
{
    NSError *error;
    
    NSString *jsonResponse = @"[{\"methodName\":\"firstMethod\",\"className\":\"ViewController\",\"methodType\":\"0\"},{\"methodName\":\"secondMethod:\",\"className\":\"ViewController\",\"methodType\":\"2\"}]";
    
    NSData *data = [jsonResponse dataUsingEncoding:NSUTF8StringEncoding];
    
    NSArray *jsonArray = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    
    if ([jsonArray isKindOfClass:[NSArray class]])
    {
        for (NSDictionary *dictionary in jsonArray)
        {
            [self swizzleMethod:dictionary[@"methodName"] ofClass:dictionary[@"className"] byMethodType:[dictionary[@"methodType"] integerValue]];
        }
    }
}


// Following method will replace the original method's implementation (received from server) with one of the predefined method.
- (void)swizzleMethod:(NSString *)originalMethodName ofClass:(NSString *)className byMethodType:(AMSwizzlerMethodType)methodType
{
    // Get swizzling method type (like try-catch/empty/return nil)
    NSString *swizzleMethodName = [self getMethodNameFromType:methodType];
    
    // Proceed only if all values are valid
    if (swizzleMethodName.length && originalMethodName.length && className.length)
    {
        // Get class whose method needs to be swizzled
        Class class = NSClassFromString(className);
        
        SEL originalSelector = NSSelectorFromString(originalMethodName);
        SEL swizzledSelector = NSSelectorFromString(swizzleMethodName);
        
        // Method whose implementation needs to be replaced
        Method originalMethod = class_getInstanceMethod(class, originalSelector);
        
        // Original methods implementation will be replaced by this method's implementation
        Method swizzledMethod = class_getInstanceMethod([self class], swizzledSelector);
        
        // Add this new method to class (Original methods implementations will be replaced by this new methods implementation)
        BOOL didAddMethod = class_addMethod(class,
                                            swizzledSelector,
                                            method_getImplementation(swizzledMethod),
                                            method_getTypeEncoding(swizzledMethod));
        
        if (didAddMethod)
        {
            // New method added to the above class, now replace the original methods implementation by new method's implementation
            class_replaceMethod(class,
                                originalSelector,
                                method_getImplementation(swizzledMethod),
                                method_getTypeEncoding(swizzledMethod));
        }
        else
        {
            // Swizzling method not added to class, replace the original methods implementation by this class method's implementation (This will be problematic if we use same method multiple times)
            method_exchangeImplementations(originalMethod, swizzledMethod);
        }
    }
}


// Get method name string from its type
- (NSString *) getMethodNameFromType:(AMSwizzlerMethodType)methodType
{
    NSString *swizzleMethodName = nil;
    
    switch (methodType)
    {
        case AMSwizzlerMethodTypeEmptyBody:
        {
            swizzleMethodName = @"emptyBodyMethod";
            break;
        }
        case AMSwizzlerMethodTypeTryCatch:
        {
            swizzleMethodName = @"tryCatchMethod";
            break;
        }
        case AMSwizzlerMethodTypeReturnEmptyString:
        {
            swizzleMethodName = @"emptyStringMethod";
            break;
        }
        case AMSwizzlerMethodTypeReturnZero:
        {
            swizzleMethodName = @"nilReturnTypeMethod";
            break;
        }
        case AMSwizzlerMethodTypeReturnNil:
        {
            swizzleMethodName = @"zeroReturnTypeMethod";
            break;
        }
    }
    
    return swizzleMethodName;
}


#pragma mark - Swizzling Methods

// Method with empty body
- (void)emptyBodyMethod
{
    NSLog(@"Changed methods implementation with empty body");
}

// Method which add try-catch to existing method
- (void)tryCatchMethod
{
    NSLog(@"Changed methods implementation to surround by try catch");
    
    @try
    {
        
    }
    @catch(NSException *exception)
    {
        NSLog(@"%@", exception);
    }
}

// Method which returns empty string as a default value
- (NSString *)emptyStringMethod
{
    NSLog(@"Changed methods implementation with empty body and returned empty string");
    return @"";
}

// Method which returns nil as a default value
- (id)nilReturnTypeMethod
{
    NSLog(@"Changed methods implementation with empty body and returned nil value");
    return nil;
}

// Method which return 0 as a default value
- (NSInteger)zeroReturnTypeMethod
{
    NSLog(@"Changed methods implementation with empty body and returned zero value");
    return 0;
}

@end
