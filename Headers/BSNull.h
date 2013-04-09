#import <Foundation/Foundation.h>

#define BS_DYNAMIC @"bs_dynamic"

#define BS_NULL [BSNull null]

@interface BSNull : NSObject<NSCopying>

+ (BSNull *)null;

@end
