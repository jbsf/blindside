#import <Foundation/Foundation.h>

#import "BSBinder.h"

@protocol BSModule;

@interface BSInjector : NSObject<BSBinder>

+ (BSInjector *)injectorWithModule:(id<BSModule>)module;

- (id)getInstance:(id)key;

@end
