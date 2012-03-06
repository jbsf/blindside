#import <Foundation/Foundation.h>

@class BSInitializer;

@interface Address : NSObject 

@end

@interface House : NSObject

@property (nonatomic, retain) Address *address;

+ (BSInitializer *)defaultBSInitializer;

- (id)initWithAddress:(Address *)address;
@end

