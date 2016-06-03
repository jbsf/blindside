#import <Foundation/Foundation.h>

@protocol BSInjector;
@protocol BSBinder;
@class BSInitializer;

@protocol TestProtocolNonExistent;

@interface State : NSObject
@end

@interface City : NSObject
@property NSUInteger population;
@end

@interface Country : NSObject
@property (nonatomic, copy) NSString *name;

+ (id)countryWithName:(NSString *)name;

@end

@interface Garage : NSObject
@property (nonatomic, assign) BOOL isEmpty;
@end

@interface Driveway : NSObject
@end

@interface Address : NSObject
@property (nonatomic, copy) NSString *street;
@property (nonatomic, strong) City *city;
@property (nonatomic, strong) State *state;
@property (nonatomic, copy) NSString *zip;

- (id)initWithStreet:(NSString *)street city:(City *)city state:(State *)state zip:(NSString *)zip;

@end

@interface Intersection : NSObject
@property (nonatomic, copy) NSString *street;
@property (nonatomic, copy) NSString *street2;
@property (nonatomic, strong) City *city;
@property (nonatomic, strong) State *state;
@property (nonatomic, copy) NSString *zip;
@end

@interface House : NSObject

@property (nonatomic, strong) Address *address;
@property (nonatomic, strong) Garage *garage;
@property (nonatomic, strong) Driveway *driveway;
@property (nonatomic, unsafe_unretained) id<BSInjector> injector;

- (id)initWithAddress:(Address *)address;
@end

@interface Cottage : NSObject
@property (nonatomic, unsafe_unretained) id<BSInjector, BSBinder> injector;
@end

@interface TennisCourt : NSObject
@end

@interface Mansion : House
@property (nonatomic, strong) TennisCourt *tennisCourt;
@end

@protocol TestProtocol <NSObject>
@end

@interface TestProtocolImpl : NSObject<TestProtocol>
@end

@protocol TestProtocol2 <NSObject>
@end

@protocol TestAliasProtocol <TestProtocol, TestProtocol2>
@end

@interface TestAliasProtocolImpl : NSObject<TestAliasProtocol>
@end


@interface ClassWithFactoryMethod : NSObject
@property (nonatomic, copy) NSString *foo;
@property (nonatomic, copy) NSString *bar;
+ bsCreateWithArgs:(NSArray *)args injector:(id<BSInjector>)injector;
@end

@class BogusClass;
@interface ClassWithBogusProperty : NSObject
@property (nonatomic, strong) BogusClass *bogus;
@end

@interface ClassWithoutDependencyDeclaration : NSObject
- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithDependency:(NSString *)dependency NS_DESIGNATED_INITIALIZER;
@end

@interface ClassWithProtocolInstance : NSObject
@property (nonatomic, strong) TestProtocolImpl *protocolInstance;
@end

@interface ClassWithProtocolProperty : NSObject
@property (nonatomic, strong) id<TestProtocol> protocolProperty;
@end

@interface ClassWithInvalidProtocolProperty : NSObject
@property (nonatomic, strong) id<TestProtocolNonExistent> invalidProtocolProperty;
@end

@interface ClassWithAliasedProtocolsProperty : NSObject
@property (nonatomic, strong) id<TestAliasProtocol> aliasProtocolProperty;
@end

@interface ClassWithMultipleProtocolsProperty : NSObject
@property (nonatomic, strong) id<TestProtocol, TestProtocol2> multipleProtocolsProperty;
@end

@interface ClassWithManuallySpecifiedMultipleProtocolsProperty : ClassWithMultipleProtocolsProperty
@end

@class ClassBDependsOnC, ClassCDependsOnA;

@interface ClassADependsOnB : NSObject
@property (nonatomic, strong) ClassBDependsOnC *b;
- (id)initWithB:(ClassBDependsOnC *)b;
@end

@interface ClassBDependsOnC : NSObject
@property (nonatomic, strong) ClassCDependsOnA *c;
- (id)initWithC:(ClassCDependsOnA *)c;
@end

@interface ClassCDependsOnA : NSObject
@property (nonatomic, strong) ClassADependsOnB *a;
- (id)initWithA:(ClassADependsOnB *)a;
@end
