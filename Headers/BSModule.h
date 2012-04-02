#import <Foundation/Foundation.h>

@protocol BSBinder;

@protocol BSModule
- (void)configure:(id<BSBinder>)binder;
@end
