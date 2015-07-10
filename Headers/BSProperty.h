#import <Foundation/Foundation.h>

#import "BSNullabilityCompat.h"

NS_ASSUME_NONNULL_BEGIN

/**
 * A representation of an Objective-C property
 */
@interface BSProperty : NSObject

@property (nonatomic, strong, null_resettable) id injectionKey;
@property (nonatomic, strong, readonly) Class returnType;
@property (nonatomic, strong, readonly) NSString *propertyNameString;

+ (BSProperty *)propertyWithClass:(Class)owningClass propertyNameString:(NSString *)propertyNameString;

- (id)injectionKey;
@end

NS_ASSUME_NONNULL_END
