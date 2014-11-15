#import "BSInitializerProvider.h"
#import "BSInjector.h"
#import "BSModule.h"
#import "BSInitializer.h"
#import "BSNull.h"
#import "BSPropertySet.h"
#import "BSProperty.h"

static NSString *const BSNilArgumentValue = @"BSNilArgumentValue";
static NSString *const BSTooManyArguments = @"BSTooManyArguments";

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
            [self raiseNilValueExceptionForKey:argKey];
        }

        [mergedArgValues addObject:argValue];
    }
    
    if (argIndex < args.count) {
        [self raiseTooManyArgsException];
    }

    id newInstance = [self.initializer bsPerform:mergedArgValues];
    [injector injectProperties:newInstance];

    return newInstance;
}

- (void)raiseTooManyArgsException {
    [NSException raise:BSTooManyArguments
                format:@"Too many dynamic arguments given for initializer %@ on class %@",
     NSStringFromSelector(self.initializer.selector), NSStringFromClass(self.initializer.type)];
}

- (void)raiseNilValueExceptionForKey:(id)argKey {
    NSString *argString = [argKey description];
    NSString *classString = NSStringFromClass(self.initializer.type);
    [NSException raise:BSNilArgumentValue
                format:@"No value was found for argument key: %@ for class: %@. This could mean you forgot to \
create a binding for %@, or forgot to create a binding for %@ itself.\n\n\
If you actually want to inject nil as an argument value, use bind:<key> toInstance:BS_NULL, \
or, if using dynamic arguments you can use BS_NULL as an argument key or argument value.", 
     argString, classString, argString, classString, nil];
}

@end
