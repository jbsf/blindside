#import <Cedar/Cedar.h>
#import <Blindside/Blindside.h>
#import "BSInjectorImpl.h"
#import "Fixtures.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(BSInjectorSpec)
describe(@"BSInjector", ^{
    __block BSInjectorImpl *injector;

    beforeEach(^{
        injector = [[BSInjectorImpl alloc] init];
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

    it(@"raises an exception if the given key produces a nil object", ^{
        ^{
            [injector getInstance:@"NotAnInstance"];
        } should raise_exception();
    });

    describe(@"building an object using a BSInitializer", ^{
        it(@"resolves first-order dependencies", ^{
            [injector bind:@"theDriveway" toInstance:BS_NULL];
            Address *address = [[Address alloc] init];
            [injector bind:[Address class] toInstance:address];
            House *house = [injector getInstance:[House class]];
            expect(house).to_not(be_nil());
            expect(house.address).to_not(be_nil());
        });

        context(@"when the initializer has more than two arguments", ^{
            it(@"injects all the arguments", ^{
                NSString *street = @"123 Market St.";
                City *city = [[City alloc] init];
                State *state = [[State alloc] init];
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
                    City *city = [[City alloc] init];

                    [injector bind:@"street" toInstance:street];
                    [injector bind:@"city"   toInstance:city];
                    
                    // zip and state remain unbound
                    
                    ^{
                        [injector getInstance:[Address class]];
                    } should raise_exception();
                });
            });
            
            context(@"when an argument key is bound to BS_NULL", ^{
                it(@"injects nil", ^{
                    NSString *street = @"123 Market St.";
                    City *city = [[City alloc] init];
                    
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

        context(@"when the class also has bsProperties", ^{
            __block Garage *garage;
            __block Driveway *driveway;

            beforeEach(^{
                [injector bind:[Address class] toInstance:BS_NULL];
                
                garage = [[Garage alloc] init];
                [injector bind:[Garage class] toInstance:garage];

                driveway = [[Driveway alloc] init];
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
            });

            context(@"when the property is bound to BS_NULL", ^{
                it(@"injects nil", ^{
                    [injector bind:@"theDriveway" toInstance:BS_NULL];

                    House *house = [injector getInstance:[House class]];
                    expect(house.driveway).to(be_nil());
                });
            });
            
            context(@"when the class implements bsAwakeFromPropertyInjection", ^{
                it(@"should call it after property injection", ^{
                    House *house = [injector getInstance:[House class]];
                    expect(house.garage.isEmpty).to(equal(YES));
                });
            });

            context(@"when the superclass has properties", ^{
                it(@"injects superclass properties too", ^{
                    [injector bind:@"10 car driveway" toInstance:BS_NULL];
                    TennisCourt *tennisCourt = [[TennisCourt alloc] init];
                    [injector bind:[TennisCourt class] toInstance:tennisCourt];

                    Mansion *mansion = [injector getInstance:[Mansion class]];
                    expect(mansion.tennisCourt == tennisCourt).to(equal(YES));
                    expect(mansion.garage == garage).to(equal(YES));
                });

                context(@"when the subclass binds a shared property", ^{
                    it(@"does not affect the superclass binding", ^{
                        Driveway *tenCarDriveway = [[Driveway alloc] init];
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

        [injector bind:@"theDriveway" toInstance:BS_NULL];
        [injector bind:[Address class] toInstance:BS_NULL];
        
        garage = [[Garage alloc] init];
        [injector bind:[Garage class] toBlock:^(NSArray *args, id<BSInjector> injector){
            return garage;
        }];

        House *house = [injector getInstance:[House class]];
        expect(house.garage == garage).to(equal(YES));
    });

    describe(@"binding to classes", ^{
        context(@"when the class has a blindside initializer", ^{
            it(@"builds the class with the blindside initializer", ^{
                [injector bind:@"theDriveway" toInstance:BS_NULL];
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

        context(@"when the key is a class which is bound to the same class", ^{
            it(@"builds the class successfully", ^{
                [injector bind:[TennisCourt class] toClass:[TennisCourt class]];
                id address = [injector getInstance:[TennisCourt class]];
                expect(address).to(be_instance_of([TennisCourt class]));
            });
        });

        context(@"when the class has a designated initializer but does not declare a blindside initializer", ^{
            it(@"raises an exception", ^{
                ^{
                    [injector getInstance:[ClassWithoutDependencyDeclaration class]];
                } should raise_exception().with_name(@"BSMissingInitializerSpecificationException");
            });
        });
    });

    describe(@"scoping", ^{
        describe(@"singleton", ^{
            it(@"uses the same instance for all injection points", ^{
                [injector bind:@"theDriveway" toInstance:BS_NULL];
                [injector bind:[Address class] toInstance:BS_NULL];
                [injector bind:[House class] withScope:[BSSingleton scope]];
                House *house1 = [injector getInstance:[House class]];
                House *house2 = [injector getInstance:[House class]];
                expect(house1 == house2).to(equal(YES));
            });

            context(@"when a class is bound to a non-class key", ^{
                it(@"uses the same instance for all injection points", ^{
                    [injector bind:@"theDriveway" toInstance:BS_NULL];
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
                [injector bind:@"theDriveway" toInstance:BS_NULL];
                [injector bind:[Address class] toInstance:BS_NULL];
                House *house1 = [injector getInstance:[House class]];
                House *house2 = [injector getInstance:[House class]];
                expect(house1 == house2).to(equal(NO));
            });
        });
    });

    context(@"when the object being retrieved has a writable injector property", ^{
        it(@"injects itself as the property value", ^{
            [injector bind:@"theDriveway" toInstance:BS_NULL];
            [injector bind:[Address class] toInstance:BS_NULL];
            House *house = [injector getInstance:[House class]];
            house.injector should equal(injector);
        });
    });

    context(@"when the object being retrieved has a writable injector property that also conforms to a protocol other than BSInjector", ^{
        it(@"injects itself as the property value", ^{
            Cottage *cottage = [injector getInstance:[Cottage class]];
            cottage.injector should equal(injector);
        });
    });

    describe(@"getInstance:withArgs:", ^{
        __block State *state;
        __block City *city;
        __block NSString *street;
        __block NSString *street2;
        __block NSString *zip;
        
        beforeEach(^{
            street = @"Guerrero";
            street2 = @"Market";
            zip = @"Guerrero";
            state = [[State alloc] init];
            city = [[City alloc] init];
            [injector bind:@"street" toInstance:street];
            [injector bind:@"street2" toInstance:street2];
            [injector bind:@"state"  toInstance:state];
        });
        
        context(@"when the are too many args", ^{
            it(@"raises an exception", ^{
                
                ^{
                   [injector getInstance:[Intersection class] withArgs:city, zip, @"too many args", nil];
                } should raise_exception();
            });
        });

        context(@"when there are too few args", ^{
            it(@"raises an exception", ^{
                ^{
                    [injector getInstance:[Intersection class] withArgs:city, nil];
                } should raise_exception();
            });
        });

        context(@"with the correct number of args", ^{
            it(@"injects the provided args along with existing bindings", ^{
                Intersection *intersection = [injector getInstance:[Intersection class] withArgs:city, zip, nil];
                intersection.street should equal(street);
                intersection.street2 should equal(street2);
                intersection.state should equal(state);
                intersection.city should equal(city);
                intersection.zip should equal(zip);
            });
        });
        
        context(@"when passing BS_NULL as an arg value", ^{
            it(@"injects nil", ^{
                Intersection *intersection = [injector getInstance:[Intersection class] withArgs:BS_NULL, zip, nil];
                intersection.street should equal(street);
                intersection.street2 should equal(street2);
                intersection.state should equal(state);
                intersection.city should be_nil;
                intersection.zip should equal(zip);
            });
        });
    });

    describe(@"injectProperties:", ^{
        __block Mansion *mansion;
        beforeEach(^{
            mansion = [[Mansion alloc] init];
        });

        context(@"when the object receiving injected property values has a writable injector property not declared in the BSPropertySet", ^{
            beforeEach(^{
                Driveway *tenCarDriveway = [[Driveway alloc] init];
                [injector bind:@"10 car driveway" toInstance:tenCarDriveway];

                [injector injectProperties:mansion];
            });

            it(@"injects itself as the property value", ^{
                mansion.injector should be_same_instance_as(injector);
            });
        });
    });

    describe(@"cyclic dependencies", ^{
        context(@"when an object's dependency directly depends on the object being retrieved", ^{
            it(@"should raise an exception indicating the dependency chain", ^{
                ^{
                    [injector getInstance:[ClassADependsOnB class]];
                } should raise_exception().with_reason(@"Cyclic dependency found on key ClassADependsOnB. The dependency chain was:\nClassADependsOnB -> ClassBDependsOnC -> ClassCDependsOnA -> ClassADependsOnB");
            });
        });
    });
});

SPEC_END
