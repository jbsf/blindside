#import "BSInjector.h"
#import "BSModule.h"
#import "BSProvider.h"
#import "BSInitializerProvider.h"
#import "BSInitializer.h"
#import "BSScope.h"

@implementation BSInjector

@synthesize module = module_;

+ (BSInjector *)injectorWithModule:(BSModule *)module {
    return [[[BSInjector alloc] initWithModule:module] autorelease];
}

- (id)initWithModule:(BSModule *)module {
    if (self = [super init]) {
        self.module = module;
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
    id<BSScope> scope = [self.module scopeForKey:key];
    
    if (provider == nil && [key respondsToSelector:@selector(blindsideInitializer)]) {
        BSInitializer *initializer = [key performSelector:@selector(blindsideInitializer)];
        provider = [BSInitializerProvider providerWithInitializer:initializer injector:self];
    }
    
    if (provider && scope) {
        provider = [scope scope:provider];
    }

    return [provider provide];
}

@end
