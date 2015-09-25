#import "NSObject+Blindside.h"
#import "BSInitializer.h"
#import "BSInjector.h"
#import "BSPropertySet.h"

static NSString *const BSMissingInitializerSpecificationException = @"BSMissingInitializerSpecificationException";

@implementation NSObject(Blindside)

+ (id)bsCreateWithArgs:(NSArray *)args injector:(id<BSInjector>)injector {
    id instance;

    @try {
        instance = [[self alloc] init];
    } @catch (NSException *exception) {
        BOOL isUnrecognizedSelectorException = ([exception.name isEqualToString:NSInvalidArgumentException] &&
                                                [exception.reason rangeOfString:@"unrecognized selector"].location != NSNotFound);
        if (!isUnrecognizedSelectorException) {
            @throw;
        }
    }

    if (!instance) {
        [NSException raise:BSMissingInitializerSpecificationException
                    format:@"Unable to create an instance of class %@ using -init. Override +bsInitializer to tell Blindside which initializer to use.", NSStringFromClass(self)];
    }

    [injector injectProperties:instance];
    return instance;
}

+ (BSInitializer *)bsInitializer {
    return nil;
}

+ (BSPropertySet *)bsProperties {
    return nil;
}

- (void)bsAwakeFromPropertyInjection {
    
}

@end
