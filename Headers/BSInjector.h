#import <Foundation/Foundation.h>

@protocol BSInjector
- (id)getInstance:(id)key;
- (id)getInstance:(id)key withArgs:(id)arg1, ... NS_REQUIRES_NIL_TERMINATION;
- (void)injectProperties:(id)instance;
@end
