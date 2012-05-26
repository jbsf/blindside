#import <Cedar/SpecHelper.h>
#import "Fixtures.h"
#import "BSInitializer.h"

@interface ClassMissingInitializer : NSObject
@end

@implementation ClassMissingInitializer
@end

using namespace Cedar::Matchers;

SPEC_BEGIN(BSInitializerSpec)
describe(@"BSInitializer", ^{

    context(@"when the initializer's class does not have a matching selector", ^{
        it(@"raises an exception", ^{
            void(^block)() = [[^{
                SEL badSelector = @selector(initWithFoo:);
                [BSInitializer initializerWithClass:[ClassMissingInitializer class] selector:badSelector argumentKeys:nil];
            } copy] autorelease];

            block should raise_exception();
        });
    });

});
SPEC_END
