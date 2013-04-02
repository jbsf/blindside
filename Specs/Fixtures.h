#import <Foundation/Foundation.h>

@protocol BSInjector;
@class BSInitializer;

@interface State : NSObject
@end

@interface City : NSObject
@property NSUInteger population;
@end

@interface Country : NSObject
@property (nonatomic, retain) NSString *name;
@end

@interface Garage : NSObject
@end

@interface Driveway : NSObject
@end

@interface Address : NSObject
@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) City *city;
@property (nonatomic, retain) State *state;
@property (nonatomic, retain) NSString *zip;

- (id)initWithStreet:(NSString *)street city:(City *)city state:(State *)state zip:(NSString *)zip;

@end

@interface Intersection : NSObject
@property (nonatomic, retain) NSString *street;
@property (nonatomic, retain) NSString *street2;
@property (nonatomic, retain) City *city;
@property (nonatomic, retain) State *state;
@property (nonatomic, retain) NSString *zip;
@end

@interface House : NSObject

@property (nonatomic, retain) Address *address;
@property (nonatomic, retain) Garage *garage;
@property (nonatomic, retain) Driveway *driveway;
@property (nonatomic, assign) id<BSInjector> injector;

- (id)initWithAddress:(Address *)address;
@end

@interface TennisCourt : NSObject
@end

@interface Mansion : House
@property (nonatomic, retain) TennisCourt *tennisCourt;
@end

@protocol TestProtocol <NSObject>
@end

@interface TestProtocolImpl : NSObject<TestProtocol>
@end

@interface ClassWithFactoryMethod : NSObject
@property (nonatomic, retain) NSString *foo;
@property (nonatomic, retain) NSString *bar;
+ bsCreateWithArgs:(NSArray *)args injector:(id<BSInjector>)injector;
@end
