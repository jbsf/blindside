#import <Cedar/Cedar.h>
#import <Blindside/Blindside.h>
#import "BSProperty.h"
#import "Fixtures.h"

using namespace Cedar::Matchers;

SPEC_BEGIN(BSPropertySpec)
describe(@"BSProperty", ^{
    __block BSProperty *property;
    
    describe(@"initializing", ^{
        context(@"when the class does not have a property with the given name", ^{
            it(@"raises an exception", ^{
                ^{
                    [BSProperty propertyWithClass:[House class] propertyNameString:@"foo"];
                } should raise_exception();
            });
        });
        
        context(@"when the property has a non-object return type", ^{
            it(@"raises an exception", ^{
                ^{
                    [BSProperty propertyWithClass:[City class] propertyNameString:@"population"];
                } should raise_exception();
            });
        });
        
        context(@"when the return type is a non-existent objective-c class", ^{
            it(@"raises an exception", ^{
                ^{
                    [BSProperty propertyWithClass:[ClassWithBogusProperty class] propertyNameString:@"bogus"];
                } should raise_exception();
            });
        });
        
        context(@"when the return type is an objective-c class", ^{
            it(@"determines the class", ^{
                property = [BSProperty propertyWithClass:[House class] propertyNameString:@"address"];
                expect(property.returnType == [Address class]).to(equal(YES));
            });
        });
        
        context(@"when the return type is an objective-c class conforming to a protocol", ^{
            it(@"determines the class", ^{
                property = [BSProperty propertyWithClass:[ClassWithProtocolInstance class] propertyNameString:@"protocolInstance"];
                expect(property.returnType == [TestProtocolImpl class]).to(equal(YES));
            });
        });
        
        context(@"when the return type is an objective-c protocol", ^{
            it(@"determines the protocol", ^{
                property = [BSProperty propertyWithClass:[ClassWithProtocolProperty class] propertyNameString:@"protocolProperty"];
                expect(property.returnType == @protocol(TestProtocol)).to(equal(YES));
            });
        });
        
        context(@"when the return type is a non-existent objective-c protocol", ^{
            it(@"raises an exception", ^{
                ^{
                    [BSProperty propertyWithClass:[ClassWithInvalidProtocolProperty class] propertyNameString:@"invalidProtocolProperty"];
                } should raise_exception().with_name(@"BSInvalidPropertyException");
            });
        });
        
        context(@"when the return type is an objective-c protocol conforming to other procotols", ^{
            it(@"determines the protocol", ^{
                property = [BSProperty propertyWithClass:[ClassWithAliasedProtocolsProperty class] propertyNameString:@"aliasProtocolProperty"];
                expect(property.returnType == @protocol(TestAliasProtocol)).to(equal(YES));
            });
        });
        
        context(@"when the return type conforms to multiple objective-c protocols", ^{
            it(@"determines nil", ^{
                property = [BSProperty propertyWithClass:[ClassWithMultipleProtocolsProperty class] propertyNameString:@"multipleProtocolsProperty"];
                property.returnType should be_nil;
            });
        });
    });
});
SPEC_END