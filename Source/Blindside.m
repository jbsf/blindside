#import "Blindside.h"
#import "BSInjectorImpl.h"

@implementation Blindside

+ (id<BSInjector>)injectorWithModule:(id<BSModule>)module {
    BSInjectorImpl *injector = [[BSInjectorImpl alloc] init];
    [module configure:injector];
    [injector bind:@"injector" toInstance:injector];
    return injector;
}
@end