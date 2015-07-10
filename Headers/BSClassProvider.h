#import <Foundation/Foundation.h>

#import "BSProvider.h"
#import "BSNullabilityCompat.h"

@protocol BSInjector;

NS_ASSUME_NONNULL_BEGIN

@interface BSClassProvider : NSObject<BSProvider> 

+ (BSClassProvider *)providerWithClass:(Class)class;

@end

NS_ASSUME_NONNULL_END
