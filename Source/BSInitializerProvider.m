#import "BSInitializerProvider.h"
#import "BSInjector.h"
#import "BSModule.h"
#import "BSInitializer.h"

@interface BSInitializerProvider ()
@property (nonatomic, assign) BSInitializer *initializer;
@property (nonatomic, assign) BSModule *module;
@end

@implementation BSInitializerProvider

@synthesize initializer = initializer_, module = module_;

+ (BSInitializerProvider *)providerWithInitializer:(BSInitializer *)initializer module:(BSModule *)module {
    return [[[BSInitializerProvider alloc] initWithInitializer:initializer module:module] autorelease];
}

- (id)initWithInitializer:(BSInitializer *)initializer module:(BSModule *)module{
    if (self = [super init]) {
        self.initializer = initializer;
        self.module      = module;
    }
    return self;
}

- (id)provide {
    if (self.initializer.numberOfArguments == 0) {
        return [self.initializer perform];        
    } else if (self.initializer.numberOfArguments == 1) {
        id argKey = [self.initializer keyForArgumentAtIndex:0];
        id<BSProvider> provider = [self.module providerForKey:argKey];
        id argValue = [provider provide];
        return [self.initializer performWithObject:argValue];        
    }
    return nil;
}

@end
