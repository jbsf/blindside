#import <Foundation/Foundation.h>

#import "BSBinder.h"

@protocol BSModule;

@interface BSInjector : NSObject<BSBinder>

+ (BSInjector *)injectorWithModule:(id<BSModule>)module;

- (id)getInstance:(id)key;
- (id)getInstance:(id)key withArgs:(id)arg1, ... NS_REQUIRES_NIL_TERMINATION;

@end
