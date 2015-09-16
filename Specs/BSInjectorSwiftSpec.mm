#import <Cedar/Cedar.h>
#import <Blindside/Blindside.h>
#import "BSInjectorImpl.h"
#import "Specs-Swift.h"

using namespace Cedar::Matchers;
using namespace Cedar::Doubles;

SPEC_BEGIN(BSInjectorSwiftSpec)

describe(@"BSInjector with NSObject-derived classes defined in Swift", ^{
    __block BSInjectorImpl *injector;

    beforeEach(^{
        injector = [[BSInjectorImpl alloc] init];
    });

    it(@"can build using a factory method", ^{
        [injector bind:@"bar" toInstance:@"BAR"];
        SwiftClassWithFactoryMethod *instance = [injector getInstance:[SwiftClassWithFactoryMethod class] withArgs:@"FOO", nil];
        instance.foo should equal(@"FOO");
        instance.bar should equal(@"BAR");
    });

    describe(@"binding to classes", ^{
        context(@"when the class has a blindside initializer", ^{
            it(@"builds the class with the blindside initializer", ^{
                [injector bind:@"theDriveway" toInstance:BS_NULL];
                [injector bind:[SwiftAddress class] toInstance:BS_NULL];
                [injector bind:@"expensivePurchase" toClass:[SwiftHouse class]];
                id expensivePurchase = [injector getInstance:@"expensivePurchase"];
                expect([expensivePurchase class]).to(equal([SwiftHouse class]));
            });
        });
    });

    context(@"when the object being retrieved has a writable injector property", ^{
#if defined(__apple_build_version__) && __apple_build_version__ >= 7000000
        it(@"injects itself as the property value", ^{
            [injector bind:@"theDriveway" toInstance:BS_NULL];
            [injector bind:[SwiftAddress class] toInstance:BS_NULL];
            SwiftHouse *house = [injector getInstance:[SwiftHouse class]];
            house.injector should equal(injector);
        });
#else
        // Until Xcode 7 / Swift 2, the metadata exposed to the Objective-C runtime for properties
        // on a Swift class does not include sufficient type information to safely write to an `injector` property
        it(@"injects itself as the property value", PENDING);
#endif
    });

    describe(@"building an object using a BSInitializer", ^{
        context(@"when the class also has bsProperties", ^{
            __block SwiftGarage *garage;
            __block SwiftDriveway *driveway;

            beforeEach(^{
                [injector bind:[SwiftAddress class] toInstance:BS_NULL];

                garage = [[SwiftGarage alloc] init];
                [injector bind:[SwiftGarage class] toInstance:garage];

                driveway = [[SwiftDriveway alloc] init];
                [injector bind:@"theDriveway" toInstance:driveway];
            });

            context(@"when there is an explicit binding for the property", ^{
                it(@"uses the binding for the injection", ^{
                    SwiftHouse *house = [injector getInstance:[SwiftHouse class]];
                    expect(house.driveway).to(be_same_instance_as(driveway));
                });
            });

            context(@"when the class implements bsAwakeFromPropertyInjection", ^{
                it(@"should call it after property injection", ^{
                    SwiftHouse *house = [injector getInstance:[SwiftHouse class]];
                    expect(house.garage.empty).to(equal(YES));
                });
            });

            context(@"when the superclass has properties", ^{
                it(@"injects superclass properties too", ^{
                    [injector bind:@"10 car driveway" toInstance:BS_NULL];
                    SwiftTennisCourt *tennisCourt = [[SwiftTennisCourt alloc] init];
                    [injector bind:[SwiftTennisCourt class] toInstance:tennisCourt];

                    SwiftMansion *mansion = [injector getInstance:[SwiftMansion class]];
                    expect(mansion.tennisCourt).to(be_same_instance_as(tennisCourt));
                    expect(mansion.garage).to(be_same_instance_as(garage));
                });
            });
        });
    });

});

SPEC_END
