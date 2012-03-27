#import <Foundation/Foundation.h>

@class BSInitializer, BSPropertySet;
@protocol BSScope;

@interface NSObject(Blindside)

+ (BSInitializer *)blinsideInitializer;
+ (BSPropertySet *)blinsideProperties;
+ (id<BSScope>)blindsideScope;

@end
