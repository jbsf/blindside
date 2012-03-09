#import "BSInjector.h"
#import "BSModule.h"
#import "BSProvider.h"
#import "BSInitializerProvider.h"
#import "BSInitializer.h"

@implementation BSInjector

@synthesize module = module_;

+ (BSInjector *)injectorWithModule:(BSModule *)module {
    return [[[BSInjector alloc] initWithModule:module] autorelease];
}

- (id)initWithModule:(BSModule *)module {
    if (self = [super init]) {
        // unfortunate bi-directional dependency. injector does not really do much as is.
        self.module = module;
        module.injector = self;
        [module configure];
    }
    return self;
}

- (void)dealloc {
    self.module = nil;
    [super dealloc];
}

- (id)getInstance:(id)key {
    id<BSProvider> provider = [self.module providerForKey:key];
    return [provider provide];
}

@end
