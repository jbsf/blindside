#import <Cedar/SpecHelper.h>
#import "BSInjector.h"
#import "Fixtures.h"
#import "BSSingleton.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(BSInjectorSpec)
describe(@"BSInjector", ^{
    __block BSInjector *injector;

    beforeEach(^{
        injector = [[[BSInjector alloc] init] autorelease];
    }); 

    it(@"can bind an instance to a class", ^{
        NSString *instance = @"foo";
        [injector bind:[NSObject class] toInstance:instance];
        id object = [injector getInstance:[NSObject class]];
        expect(object == instance).to(equal(YES));
    });

    it(@"can bind an instance to a string", ^{
        NSString *instance = @"foo";
        [injector bind:@"key" toInstance:instance];
        id object = [injector getInstance:@"key"];
        expect(object == instance).to(equal(YES));
    });

    describe(@"building an object whose class has a blindsideInitializer", ^{
        it(@"resolves first-order dependencies", ^{
            Address *address = [[[Address alloc] init] autorelease];
            [injector bind:[Address class] toInstance:address];
            House *house = [injector getInstance:[House class]];
            expect(house).to_not(be_nil());
            expect(house.address).to_not(be_nil());
        });

        context(@"when the initializer has more than two arguments", ^{
            it(@"injects all the arguments", ^{
                NSString *street = @"123 Market St.";
                City *city = [[[City alloc] init] autorelease];
                State *state = [[[State alloc] init] autorelease];
                NSString *zip = @"94110";
                
                [injector bind:@"street" toInstance:street];
                [injector bind:@"city"   toInstance:city];
                [injector bind:@"state"  toInstance:state];
                [injector bind:@"zip"    toInstance:zip];
                
                Address *address = [injector getInstance:[Address class]];
                
                expect(address.street == street).to(equal(YES));
                expect(address.city   == city).to(equal(YES));
                expect(address.state  == state).to(equal(YES));
                expect(address.zip    == zip).to(equal(YES));
            });
            
            context(@"when some argument keys have no bound values", ^{
                it(@"injects nil", ^{
                    NSString *street = @"123 Market St.";
                    City *city = [[[City alloc] init] autorelease];
                    
                    [injector bind:@"street" toInstance:street];
                    [injector bind:@"city"   toInstance:city];
                    
                    Address *address = [injector getInstance:[Address class]];
                    
                    expect(address.street == street).to(equal(YES));
                    expect(address.city   == city).to(equal(YES));
                    expect(address.state).to(be_nil);
                    expect(address.zip).to(be_nil);                    
                });
            });
        });

        context(@"when the class also has blindsideProperties", ^{
            __block Garage *garage;
            __block Driveway *driveway;

            beforeEach(^{
                garage = [[[Garage alloc] init] autorelease];
                [injector bind:[Garage class] toInstance:garage];

                driveway = [[[Driveway alloc] init] autorelease];
                [injector bind:@"theDriveway" toInstance:driveway];
            });

            it(@"injects the properties", ^{
                House *house = [injector getInstance:[House class]];
                expect(house.garage == garage).to(equal(YES));
                expect(house.driveway == driveway).to(equal(YES));
            });

            xit(@"injects superclass properties too", ^{
                TennisCourt *tennisCourt = [[[TennisCourt alloc] init] autorelease];
                [injector bind:[TennisCourt class] toInstance:tennisCourt];

                Mansion *mansion = [injector getInstance:[Mansion class]];
                expect(mansion.tennisCourt == tennisCourt).to(equal(YES));
                expect(mansion.garage == garage).to(equal(YES));
                expect(mansion.driveway == driveway).to(equal(YES));
            });
        });
    });
    
    it(@"binds to blocks", ^{
        __block Garage *garage;

        garage = [[[Garage alloc] init] autorelease];
        [injector bind:[Garage class] toBlock:^{
            return garage;
        }];

        House *house = [injector getInstance:[House class]];
        expect(house.garage == garage).to(equal(YES));
    });
    
    describe(@"binding to classes", ^{
        context(@"when the class has a blindside initializer", ^{
            it(@"builds the class with the blindside initializer", ^{
                [injector bind:@"expensivePurchase" toClass:[House class]];
                id expensivePurchase = [injector getInstance:@"expensivePurchase"];
                expect([expensivePurchase class]).to(equal([House class]));
            });
        });

        context(@"when the class does not explictly declare a blindside initializer", ^{
            xit(@"builds the class with the default initializer", ^{
                [injector bind:@"recreationalFacility" toClass:[TennisCourt class]];
                id recreationalFacility = [injector getInstance:@"recreationalFacility"];
                expect([recreationalFacility class]).to_not(be_nil);
            });
        });

        context(@"when the class has no blindside initializer nor default initializer", ^{
            xit(@"raises", ^{

            });
        });
    });
    
    describe(@"scoping", ^{
        describe(@"singleton", ^{
            it(@"uses the same instance for all injection points", ^{
                [injector bind:[House class] withScope:[BSSingleton scope]];
                House *house1 = [injector getInstance:[House class]];
                House *house2 = [injector getInstance:[House class]];
                expect(house1 == house2).to(equal(YES));
            });
        });

        describe(@"unscoped", ^{
            it(@"uses a different instance for each injection point", ^{
                House *house1 = [injector getInstance:[House class]];
                House *house2 = [injector getInstance:[House class]];
                expect(house1 == house2).to(equal(NO));
            });
        });
    });

    context(@"when the object being retrieved has a writable blindsideInjector property", ^{
        it(@"injects itself as the property value", ^{
            House *house = [injector getInstance:[House class]];
            house.injector should equal(injector);
        });
    });
});
SPEC_END