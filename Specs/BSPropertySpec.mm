#import <Cedar/SpecHelper.h>
#import "Fixtures.h"
#import "BSProperty.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(BSPropertySpec)
describe(@"BSProperty", ^{
    __block BSProperty *property;

    describe(@"initializing", ^{
        context(@"when the class does not have a property with the given name", ^{
            it(@"raises an exception", ^{
                [[^{
                    [[[BSProperty alloc] initWithClass:[House class] propertyName:@"foo"] autorelease];
                } copy] autorelease] should raise_exception();
            });
        });

        context(@"when the property has a non-object return type", ^{
            it(@"raises an exception", ^{
                [[^{
                    [[[BSProperty alloc] initWithClass:[City class] propertyName:@"population"] autorelease];
                } copy] autorelease] should raise_exception();
            });
        });

        context(@"when the return type is an objective-c class", ^{
            it(@"determines the class", ^{
                property = [[[BSProperty alloc] initWithClass:[House class] propertyName:@"address"] autorelease];
                expect(property.returnType == [Address class]).to(equal(YES));
            });
        });
    });
});
SPEC_END