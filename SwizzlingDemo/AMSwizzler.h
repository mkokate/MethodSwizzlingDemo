//
//  AMSwizzler.h
//  SwizzlingDemo
//
//  Created by Mahesh Kokate on 25/06/16.
//  Copyright © 2016 Mahesh Kokate. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, AMSwizzlerMethodType)
{
    AMSwizzlerMethodTypeEmptyBody,
    AMSwizzlerMethodTypeTryCatch,
    AMSwizzlerMethodTypeReturnEmptyString,
    AMSwizzlerMethodTypeReturnNil,
    AMSwizzlerMethodTypeReturnZero
};

@interface AMSwizzler : NSObject

- (void)swizzleMethods;
- (void)swizzleMethod:(NSString *)originalMethodName ofClass:(NSString *)className byMethodType:(AMSwizzlerMethodType)methodType;

@end
