#import <Cedar/SpecHelper.h>
#import "BSModule.h"
#import "BSInjector.h"
#import "Fixtures.h"
#import "BSSingleton.h"
#import "BSPropertySet.h"
#import "BSProperty.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(BSPropertySetSpec)
describe(@"BSProperty", ^{
    describe(@"#propertySet", ^{
        it(@"adds BSProperty for each property name in the list", ^{
//            BSPropertySet *propertySet = [BSPropertySet propertySet:@"address", @"city", @"state", @"zip", nil];
        });
    });
});
SPEC_END