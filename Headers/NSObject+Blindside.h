#import <Foundation/Foundation.h>

@class BSInitializer, BSPropertySet;
@protocol BSScope;

@interface NSObject(Blindside)

+ (BSInitializer *)blindsideInitializer;
+ (BSPropertySet *)blindsideProperties;
+ (id<BSScope>)blindsideScope;

@end
