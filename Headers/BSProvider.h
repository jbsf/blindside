#import <Foundation/Foundation.h>

#import "BSNullabilityCompat.h"

@protocol BSInjector;

NS_ASSUME_NONNULL_BEGIN

@protocol BSProvider <NSObject>

- (id)provide:(NSArray *)args injector:(id<BSInjector>)injector;

@end

NS_ASSUME_NONNULL_END
