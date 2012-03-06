#import <Cedar/SpecHelper.h>
#import "BSModule.h"
#import "BSInjector.h"
#import "Fixtures.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(BSInjectorSpec)
describe(@"BSInjector", ^{
    __block BSModule *module;
    __block BSInjector *injector;
    
    beforeEach(^{
        module = [BSModule module];
        injector = [[[BSInjector alloc] initWithModule:module] autorelease];
    }); 
    
    it(@"can bind an instance to a class", ^{
        NSString *instance = @"foo";
        [module bind:[NSObject class] toInstance:instance];
        id object = [injector getInstance:[NSObject class]];
        expect(object == instance).to(equal(YES));
    });
    
    it(@"can bind an instance to a string", ^{
        NSString *instance = @"foo";
        [module bind:@"key" toInstance:instance];
        id object = [injector getInstance:@"key"];
        expect(object == instance).to(equal(YES));
    });
    
    it(@"can create objects using declared blindside initializers", ^{        
//        House *house = [injector getInstance:[House class]];
//        expect(house).to_not(be_nil());
    });

    it(@"can resolve first-order dependencies", ^{
        Address *address = [[[Address alloc] init] autorelease];
        [module bind:[Address class] toInstance:address];
        House *house = [injector getInstance:[House class]];
        expect(house).to_not(be_nil());
        expect(house.address).to_not(be_nil());
    });
});
SPEC_END