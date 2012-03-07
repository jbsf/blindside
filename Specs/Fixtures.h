#import <Foundation/Foundation.h>

@class BSInitializer;

@interface State : NSObject
@end

@interface City : NSObject
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

+ (BSInitializer *)blindsideInitializer;
- (id)initWithStreet:(NSString *)street city:(City *)city state:(State *)state zip:(NSString *)zip;

@end

@interface House : NSObject

@property (nonatomic, retain) Address *address;
@property (nonatomic, retain) Garage *garage;
@property (nonatomic, retain) Driveway *driveway;

+ (BSInitializer *)blindsideInitializer;
+ (NSDictionary *)blindsideProperties;

- (id)initWithAddress:(Address *)address;
@end

