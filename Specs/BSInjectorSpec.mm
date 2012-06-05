#import <Cedar/SpecHelper.h>
#import "BSInjectorImpl.h"
#import "Fixtures.h"
#import "BSSingleton.h"
#import "BSNull.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(BSInjectorSpec)
describe(@"BSInjector", ^{
    __block BSInjectorImpl *injector;

    beforeEach(^{
        injector = [[[BSInjectorImpl alloc] init] autorelease];
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

    it(@"can bind an instance to a protocol", ^{
        TestProtocolImpl *protocolImpl = [[TestProtocolImpl alloc] init];
        [injector bind:@protocol(TestProtocol) toInstance:protocolImpl];
        id object = [injector getInstance:@protocol(TestProtocol)];
        expect(object == protocolImpl).to(equal(YES));
    });
    
    it(@"can build using a factory method", ^{
        [injector bind:@"bar" toInstance:@"BAR"];
        ClassWithFactoryMethod *instance = [injector getInstance:[ClassWithFactoryMethod class] withArgs:@"FOO", nil];
        instance.foo should equal(@"FOO");
        instance.bar should equal(@"BAR");
    });

    describe(@"building an object using a BSInitializer", ^{
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

            context(@"when an argument key does not have a bound value", ^{
                it(@"raises an exception", ^{
                    NSString *street = @"123 Market St.";
                    City *city = [[[City alloc] init] autorelease];

                    [injector bind:@"street" toInstance:street];
                    [injector bind:@"city"   toInstance:city];
                    
                    // zip and state remain unbound
                    
                    void(^block)() = [[^{
                        [injector getInstance:[Address class]];
                    } copy] autorelease];
                    
                    block should raise_exception();
                });
            });
            
            context(@"when an argument key is bound to BS_NULL", ^{
                it(@"injects nil", ^{
                    NSString *street = @"123 Market St.";
                    City *city = [[[City alloc] init] autorelease];
                    
                    [injector bind:@"street" toInstance:street];
                    [injector bind:@"city"   toInstance:city];
                    [injector bind:@"zip"    toInstance:BS_NULL];
                    [injector bind:@"state"  toInstance:BS_NULL];
                    
                    Address *address = [injector getInstance:[Address class]];
                    
                    expect(address.street == street).to(equal(YES));
                    expect(address.city == city).to(equal(YES));
                    expect(address.state).to(be_nil);
                    expect(address.zip).to(be_nil);
                });
            });
        });

        context(@"when the class also has blindsideProperties", ^{
            __block Garage *garage;
            __block Driveway *driveway;

            beforeEach(^{
                [injector bind:[Address class] toInstance:BS_NULL];
                
                garage = [[[Garage alloc] init] autorelease];
                [injector bind:[Garage class] toInstance:garage];

                driveway = [[[Driveway alloc] init] autorelease];
                [injector bind:@"theDriveway" toInstance:driveway];
            });

            context(@"when there is an explicit binding for the property", ^{
                it(@"uses the binding for the injection", ^{
                    House *house = [injector getInstance:[House class]];
                    expect(house.driveway == driveway).to(equal(YES));
                });
            });

            context(@"when the property does not have an explicit binding", ^{
                it(@"uses the binding for the property's return type", ^{
                    House *house = [injector getInstance:[House class]];
                    expect(house.garage == garage).to(equal(YES));
                });

                context(@"and the property's return type is a protocol", ^{

                });
            });

            context(@"when the superclass has properties", ^{
                it(@"injects superclass properties too", ^{
                    TennisCourt *tennisCourt = [[[TennisCourt alloc] init] autorelease];
                    [injector bind:[TennisCourt class] toInstance:tennisCourt];

                    Mansion *mansion = [injector getInstance:[Mansion class]];
                    expect(mansion.tennisCourt == tennisCourt).to(equal(YES));
                    expect(mansion.garage == garage).to(equal(YES));
                });

                context(@"when the subclass binds a shared property", ^{
                    it(@"does not affect the superclass binding", ^{
                        Driveway *tenCarDriveway = [[[Driveway alloc] init] autorelease];
                        [injector bind:@"10 car driveway" toInstance:tenCarDriveway];

                        Mansion *mansion = [injector getInstance:[Mansion class]];
                        House *house = [injector getInstance:[House class]];

                        expect(mansion.driveway == tenCarDriveway).to(equal(YES));
                        expect(house.driveway == driveway).to(equal(YES));
                    });
                });
            });
        });
    });

    it(@"binds to blocks", ^{
        __block Garage *garage;

        [injector bind:[Address class] toInstance:BS_NULL];
        
        garage = [[[Garage alloc] init] autorelease];
        [injector bind:[Garage class] toBlock:^(NSArray *args, id<BSInjector> injector){
            return garage;
        }];

        House *house = [injector getInstance:[House class]];
        expect(house.garage == garage).to(equal(YES));
    });

    describe(@"binding to classes", ^{
        context(@"when the class has a blindside initializer", ^{
            it(@"builds the class with the blindside initializer", ^{
                [injector bind:[Address class] toInstance:BS_NULL];
                [injector bind:@"expensivePurchase" toClass:[House class]];
                id expensivePurchase = [injector getInstance:@"expensivePurchase"];
                expect([expensivePurchase class]).to(equal([House class]));
            });
        });

        context(@"when the class does not explictly declare a blindside initializer", ^{
            it(@"builds the class with the default initializer", ^{
                [injector bind:@"recreationalFacility" toClass:[TennisCourt class]];
                id recreationalFacility = [injector getInstance:@"recreationalFacility"];
                expect([recreationalFacility class]).to_not(be_nil);
            });
        });
    });

    describe(@"scoping", ^{
        describe(@"singleton", ^{
            it(@"uses the same instance for all injection points", ^{
                [injector bind:[Address class] toInstance:BS_NULL];
                [injector bind:[House class] withScope:[BSSingleton scope]];
                House *house1 = [injector getInstance:[House class]];
                House *house2 = [injector getInstance:[House class]];
                expect(house1 == house2).to(equal(YES));
            });

            context(@"when a class is bound to a non-class key", ^{
                it(@"uses the same instance for all injection points", ^{
                    [injector bind:[Address class] toInstance:BS_NULL];
                    [injector bind:@"house" toClass:[House class]];
                    [injector bind:[House class] withScope:[BSSingleton scope]];
                    House *house1 = [injector getInstance:@"house"];
                    House *house2 = [injector getInstance:@"house"];
                    House *house3 = [injector getInstance:[House class]];
                    House *house4 = [injector getInstance:[House class]];
                    expect(house1 == house2 && house2 == house3 && house3 == house4).to(equal(YES));
                });
            });
        });

        describe(@"unscoped", ^{
            it(@"uses a different instance for each injection point", ^{
                [injector bind:[Address class] toInstance:BS_NULL];
                House *house1 = [injector getInstance:[House class]];
                House *house2 = [injector getInstance:[House class]];
                expect(house1 == house2).to(equal(NO));
            });
        });
    });

    context(@"when the object being retrieved has a writable blindsideInjector property", ^{
        it(@"injects itself as the property value", ^{
            [injector bind:[Address class] toInstance:BS_NULL];
            House *house = [injector getInstance:[House class]];
            house.injector should equal(injector);
        });
    });

    describe(@"getInstance:withArgs:", ^{
        __block State *state;
        __block City *city;
        __block NSString *street;
        __block NSString *zip;
        
        beforeEach(^{
            street = @"Guerrero";
            zip = @"Guerrero";
            state = [[[State alloc] init] autorelease];
            city = [[[City alloc] init] autorelease];
            [injector bind:@"street" toInstance:street];
            [injector bind:@"state"  toInstance:state];
        });
        
        context(@"when the are too many args", ^{
            it(@"raises an exception", ^{
                
                void(^block)() = [[^{
                   [injector getInstance:[Address class] withArgs:city, zip, @"too many args", nil];
                } copy] autorelease];
                
                block should raise_exception();
            });
        });

        context(@"when there are too few args", ^{
            it(@"raises an exception", ^{
                
                void(^block)() = [[^{
                    [injector getInstance:[Address class] withArgs:city, nil];
                } copy] autorelease];
                
                block should raise_exception();                
            });
        });

        context(@"with the correct number of args", ^{
            it(@"injects the provided args along with existing bindings", ^{
                Address *address = [injector getInstance:[Address class] withArgs:city, zip, nil];
                address.street should equal(street);
                address.state should equal(state);
                address.city should equal(city);
                address.zip should equal(zip);
            });
        });
        
        context(@"when passing BS_NULL as an arg value", ^{
            it(@"injects nil", ^{
                Address *address = [injector getInstance:[Address class] withArgs:BS_NULL, zip, nil];
                address.street should equal(street);
                address.state should equal(state);
                address.city should be_nil;
                address.zip should equal(zip);                
            });
        });
    });
});
SPEC_END
