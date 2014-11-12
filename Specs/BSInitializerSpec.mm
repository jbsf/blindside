#import <Cedar/Cedar.h>
#import "Fixtures.h"
#import "BSInitializer.h"
#import "Blindside.h"

@interface ClassMissingInitializer : NSObject
@end

@implementation ClassMissingInitializer
@end

using namespace Cedar::Matchers;

SPEC_BEGIN(BSInitializerSpec)
describe(@"BSInitializer", ^{

    context(@"when the initializer's class does not have a matching initialize selector", ^{
        it(@"raises an exception", ^{
            void(^block)() = [[^{
                SEL badSelector = NSSelectorFromString(@"initWithFoo:");
                [BSInitializer initializerWithClass:[ClassMissingInitializer class] selector:badSelector argumentKeys:nil];
            } copy] autorelease];

            block should raise_exception();
        });
    });

    context(@"when the initializer's class does not have a matching class selector", ^{
        it(@"raises an exception", ^{
            void(^block)() = [[^{
                SEL badSelector = NSSelectorFromString(@"initWithFoo:");
                [BSInitializer initializerWithClass:[ClassMissingInitializer class] classSelector:badSelector argumentKeys:nil];
            } copy] autorelease];

            block should raise_exception();
        });
    });

    context(@"when the initializer's class does not have the same number of arguments as the selector", ^{
        it(@"raises an exception", ^{
            void(^block)() = [[^{
                SEL goodSelector = @selector(initWithAddress:);
                [BSInitializer initializerWithClass:[House class] selector:goodSelector argumentKeys:BS_NULL, BS_NULL, nil];
            } copy] autorelease];

            block should raise_exception();
        });
    });

    it(@"can initialize using class methods", ^{
        BSInitializer *initializer = [BSInitializer initializerWithClass:[Country class] classSelector:@selector(countryWithName:) argumentKeys:BS_DYNAMIC, nil];
        Country *usa = [initializer bsPerform:@[@"USA"]];
        usa should be_instance_of([Country class]);
        usa.name should equal(@"USA");
    });

});
SPEC_END
