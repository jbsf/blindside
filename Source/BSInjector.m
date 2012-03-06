#import "BSInjector.h"
#import "BSModule.h"
#import "BSProvider.h"

@implementation BSInjector

@synthesize module = module_;

- (id)initWithModule:(BSModule *)module {
    if (self = [super init]) {
        self.module = module;
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
