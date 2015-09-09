#import <Foundation/Foundation.h>

#import "BSProvider.h"
#import "BSNullabilityCompat.h"

NS_ASSUME_NONNULL_BEGIN

@interface BSInstanceProvider : NSObject<BSProvider> 

+ (BSInstanceProvider *)provider:(id)instance;

@end

NS_ASSUME_NONNULL_END
