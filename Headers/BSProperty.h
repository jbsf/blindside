#import <Foundation/Foundation.h>

/**
 * A representation of an Objective-C property
 */
@interface BSProperty : NSObject

@property (nonatomic, strong) id injectionKey;
@property (nonatomic, weak, readonly) Class returnType;
@property (nonatomic, strong, readonly) NSString *propertyNameString;

+ (BSProperty *)propertyWithClass:(Class)owningClass propertyNameString:(NSString *)propertyNameString;

- (id)injectionKey;
@end