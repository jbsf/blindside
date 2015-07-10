#import <Foundation/Foundation.h>

#import "BSNullabilityCompat.h"

NS_ASSUME_NONNULL_BEGIN

@protocol BSInjector
- (id)getInstance:(id)key;
- (id)getInstance:(id)key withArgs:(nullable id)arg1, ... NS_REQUIRES_NIL_TERMINATION;
- (void)injectProperties:(id)instance;
@end

NS_ASSUME_NONNULL_END
