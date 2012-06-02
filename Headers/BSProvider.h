#import <Foundation/Foundation.h>
@protocol BSInjector;
@protocol BSProvider <NSObject>

- (id)provide:(NSArray *)args injector:(id<BSInjector>)injector;

@end
