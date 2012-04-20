#import "BSInitializerProvider.h"
#import "BSInjector.h"
#import "BSModule.h"
#import "BSInitializer.h"
#import "BSNull.h"
#import "BSPropertySet.h"
#import "BSProperty.h"

@interface BSInitializerProvider ()

@property (nonatomic, retain) BSInitializer *initializer;
@property (nonatomic, assign) id<BSInjector> injector;

- (id)initWithInitializer:(BSInitializer *)initializer injector:(id<BSInjector>)injector;

- (void)injectProperties:(id)instance;

@end

@implementation BSInitializerProvider

@synthesize initializer = _initializer, injector = _injector;

+ (BSInitializerProvider *)providerWithInitializer:(BSInitializer *)initializer injector:(id<BSInjector>)injector {
    return [[[BSInitializerProvider alloc] initWithInitializer:initializer injector:injector] autorelease];
}

- (id)initWithInitializer:(BSInitializer *)initializer injector:(id<BSInjector>)injector {
    if (self = [super init]) {
        self.initializer = initializer;
        self.injector = injector;
    }
    return self;
}

- (void)dealloc {
    self.initializer = nil;
    [super dealloc];
}

- (id)provide:(NSArray *)args {
    NSMutableArray *mergedArgValues = [NSMutableArray array];
    NSUInteger argIndex = 0;
    for (id argKey in self.initializer.argumentKeys) {
        id argValue = [self.injector getInstance:argKey];

        if (argValue == nil && argIndex < args.count) {
            argValue = [args objectAtIndex:argIndex];
            argIndex++;
        }
        if (argValue == nil) {
            argValue = [BSNull null];
        }

        [mergedArgValues addObject:argValue];
    }

    id newInstance = [self.initializer perform:mergedArgValues];
    [self injectProperties:newInstance];

    return newInstance;
}

- (void)injectProperties:(id)instance {
    if ([[instance class] respondsToSelector:@selector(blindsideProperties)]) {
        BSPropertySet *propertySet = [[instance class] performSelector:@selector(blindsideProperties)];
        for (BSProperty *property in propertySet) {
            id value = [self.injector getInstance:property.injectionKey];
            [instance setValue:value forKey:property.propertyName];
        }
    }
}

@end
