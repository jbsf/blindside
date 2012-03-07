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

    describe(@"building an object whose class has a blindsideInitializer", ^{
        it(@"can resolve first-order dependencies", ^{
            Address *address = [[[Address alloc] init] autorelease];
            [module bind:[Address class] toInstance:address];
            House *house = [injector getInstance:[House class]];
            expect(house).to_not(be_nil());
            expect(house.address).to_not(be_nil());
        });
        
        context(@"when the class also has blindsideProperties", ^{
            it(@"injects the properties", ^{
                Address *address = [[[Address alloc] init] autorelease];
                [module bind:[Address class] toInstance:address];

                Garage *garage = [[[Garage alloc] init] autorelease];
                [module bind:[Garage class] toInstance:garage];
                
                Driveway *driveway = [[[Driveway alloc] init] autorelease];
                [module bind:[Driveway class] toInstance:driveway];
                
                House *house = [injector getInstance:[House class]];
                expect(house.garage == garage).to(equal(YES));
                expect(house.driveway == driveway).to(equal(YES));                
            });            
        });
    });
    
    
    
});
SPEC_END