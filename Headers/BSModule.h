#import <Foundation/Foundation.h>

#import "BSNullabilityCompat.h"

@protocol BSBinder;

NS_ASSUME_NONNULL_BEGIN

@protocol BSModule
- (void)configure:(id<BSBinder>)binder;
@end

NS_ASSUME_NONNULL_END
