#import "BSInitializerProvider.h"
#import "BSInjector.h"
#import "BSModule.h"
#import "BSInitializer.h"

@interface BSInitializerProvider ()

@property (nonatomic, assign) BSInitializer *initializer;
@property (nonatomic, assign) BSInjector *injector;

- (void)injectProperties:(id)instance;

@end

@implementation BSInitializerProvider

@synthesize initializer = initializer_, injector = injector_;

+ (BSInitializerProvider *)providerWithInitializer:(BSInitializer *)initializer injector:(BSInjector *)injector {
    return [[[BSInitializerProvider alloc] initWithInitializer:initializer injector:injector] autorelease];
}

- (id)initWithInitializer:(BSInitializer *)initializer injector:(BSInjector *)injector{
    if (self = [super init]) {
        self.initializer = initializer;
        self.injector    = injector;
    }
    return self;
}

- (id)provide {
    if (self.initializer.numberOfArguments == 0) {
        return [self.initializer perform];        
    } else if (self.initializer.numberOfArguments == 1) {
        id argKey = [self.initializer keyForArgumentAtIndex:0];
        id argValue = [self.injector getInstance:argKey];
        id newInstance = [self.initializer performWithObject:argValue];
        [self injectProperties:newInstance];
        return newInstance;
    }
    return nil;
}

- (void)injectProperties:(id)instance {
    if ([[instance class] respondsToSelector:@selector(blindsideProperties)]) {
        NSDictionary *properties = [[instance class] performSelector:@selector(blindsideProperties)];
        for (id propertyName in properties) {
            id argKey = [properties objectForKey:propertyName];
            id argValue = [self.injector getInstance:argKey];
            [instance setValue:argValue forKey:propertyName];
        }
    }
}

@end
