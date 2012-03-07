#import <Foundation/Foundation.h>

@class BSInitializer;

@interface Garage : NSObject
@end

@interface Driveway : NSObject
@end

@interface Address : NSObject 

@end

@interface House : NSObject

@property (nonatomic, retain) Address *address;
@property (nonatomic, retain) Garage *garage;
@property (nonatomic, retain) Driveway *driveway;

+ (BSInitializer *)blindsideInitializer;
+ (NSDictionary *)blindsideProperties;

- (id)initWithAddress:(Address *)address;
@end

