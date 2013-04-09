#import "Fixtures.h"
#import "BSInitializer.h"
#import "BSPropertySet.h"
#import "BSInjector.h"
#import "Blindside.h"

#import <objc/runtime.h>


@implementation State
@end

@implementation City
@synthesize population = population_;
@end

@implementation Country
@synthesize name = name_;

+ (BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:self
                                 classSelector:@selector(countryWithName:)
                                  argumentKeys:@"countryName", nil];
}

+ (id)countryWithName:(NSString *)name
{
    Country *value = [self new];
    value.name = name;
    return value;
}
@end

@implementation Garage
@end

@implementation Driveway
@end

@implementation Address : NSObject

@synthesize
street = street_,
city = city_,
state = state_,
zip = zip_;

+ (BSInitializer *)bsInitializer {
    BSInitializer *initializer = [BSInitializer initializerWithClass:self selector:@selector(initWithStreet:city:state:zip:)
                                  argumentKeys:@"street", @"city", @"state", @"zip", nil];
    return initializer;
}

- (id)initWithStreet:(NSString *)street city:(City *)city state:(State *)state zip:(NSString *)zip {
    if (self = [super init]) {
        self.street = street;
        self.city = city;
        self.state = state;
        self.zip = zip;
    }
    return self;
}

@end

@implementation Intersection

@synthesize
street = street_,
street2 = street2_,
city = city_,
state = state_,
zip = zip_;

+ (BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:self
                                      selector:@selector(initWithStreet:andStreet:city:state:zip:)
                                  argumentKeys:@"street", @"street2", BS_DYNAMIC, @"state", BS_DYNAMIC, nil];
}

- (id)initWithStreet:(NSString *)street
           andStreet:(NSString *)street2
                city:(City *)city
               state:(State *)state
                 zip:(NSString *)zip {
    if (self = [super init]) {
        self.street = street;
        self.street2 = street2;
        self.city = city;
        self.state = state;
        self.zip = zip;
    }
    return self;
}

@end

@implementation House : NSObject

@synthesize address = _address, garage = _garage, driveway = _driveway, injector = _injector;

+ (BSInitializer *)bsInitializer {
    return [BSInitializer initializerWithClass:self selector:@selector(initWithAddress:) argumentKeys:[Address class], nil];
}

+ (BSPropertySet *)bsProperties {
    BSPropertySet *propertySet = [BSPropertySet propertySetWithClass:self propertyNames:@"garage", @"driveway", nil];
    [propertySet bindProperty:@"driveway" toKey:@"theDriveway"];
    return propertySet;
}

- (id)initWithAddress:(Address *)address {
    if (self = [super init]) {
        self.address = address;
    }
    return self;
}

@end

@implementation TennisCourt
@end

@implementation Mansion

@synthesize tennisCourt = tennisCourt_;

+ (BSPropertySet *)bsProperties {
    BSPropertySet *propertySet = [BSPropertySet propertySetWithClass:self propertyNames:@"tennisCourt", nil];
    [propertySet bindProperty:@"driveway" toKey:@"10 car driveway"];

    return propertySet;
}

@end

@implementation TestProtocolImpl
@end

@implementation ClassWithFactoryMethod 
@synthesize foo = _foo, bar = _bar;

+ bsCreateWithArgs:(NSArray *)args injector:(id<BSInjector>)injector {
    NSString *foo = [args objectAtIndex:0];
    NSString *bar = [injector getInstance:@"bar"];
    return [[ClassWithFactoryMethod alloc] initWithFoo:foo bar:bar];
}

- (id)initWithFoo:(NSString *)foo bar:(NSString *)bar {
    self = [super init];
    if (self) {
        self.foo = foo;
        self.bar = bar;
    }
    return self;
}
@end
