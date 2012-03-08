#import "BSInitializerProvider.h"
#import "BSInjector.h"
#import "BSModule.h"
#import "BSInitializer.h"

@interface BSInitializerProvider ()

@property (nonatomic, retain) BSInitializer *initializer;
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

- (void)dealloc {
    self.initializer = nil;
    [super dealloc];
}

- (id)provide {
    NSMutableArray *argValues = [NSMutableArray array];
    
    for (id argKey in self.initializer.argumentKeys) {
        id argValue = [self.injector getInstance:argKey];
        [argValues addObject:argValue];
    }
    
    id newInstance = [self.initializer perform:argValues];    
    [self injectProperties:newInstance];
    
    return newInstance;
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
