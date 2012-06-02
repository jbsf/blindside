#import "BSInitializerProvider.h"
#import "BSInjector.h"
#import "BSModule.h"
#import "BSInitializer.h"
#import "BSNull.h"
#import "BSPropertySet.h"
#import "BSProperty.h"

@interface BSInitializerProvider ()

@property (nonatomic, strong) BSInitializer *initializer;

- (id)initWithInitializer:(BSInitializer *)initializer;

@end

@implementation BSInitializerProvider

@synthesize initializer = _initializer;

+ (BSInitializerProvider *)providerWithInitializer:(BSInitializer *)initializer {
    return [[BSInitializerProvider alloc] initWithInitializer:initializer];
}

- (id)initWithInitializer:(BSInitializer *)initializer {
    if (self = [super init]) {
        self.initializer = initializer;
    }
    return self;
}

- (id)provide:(NSArray *)args injector:(id<BSInjector>)injector {
    NSMutableArray *mergedArgValues = [NSMutableArray array];
    NSUInteger argIndex = 0;
    for (id argKey in self.initializer.argumentKeys) {
        id argValue = [injector getInstance:argKey];

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
    [injector injectProperties:newInstance];

    return newInstance;
}

@end
