import Foundation
import Blindside

class SwiftState : NSObject {}
class SwiftCity : NSObject {
    @objc var population = 0
}

class SwiftGarage : NSObject {
    @objc var empty = true
}

class SwiftDriveway : NSObject {}

class SwiftAddress : NSObject {
    @objc var street: String
    @objc var city: SwiftCity
    @objc var state: SwiftState
    @objc var zip: String

    static override func bsInitializer() -> BSInitializer {
        return BSInitializer(with: self, selector: #selector(SwiftAddress.init(street:city:state:zip:)), argumentKeysArray: ["street", "city", "state", "zip"])
    }

    @objc init(street: String, city: SwiftCity, state: SwiftState, zip: String) {
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
    }
}

class SwiftHouse : NSObject {
    @objc var address: SwiftAddress
    @objc var garage: SwiftGarage!
    @objc var driveway: SwiftDriveway!
    @objc weak var injector: BSInjector!

    static override func bsInitializer() -> BSInitializer {
        return BSInitializer(with: self, selector: #selector(SwiftHouse.init(address:)), argumentKeysArray: [SwiftAddress.self])
    }

    class override func bsProperties() -> BSPropertySet {
        let propertySet = BSPropertySet(with: self, propertyNamesArray: ["garage", "driveway"])
        propertySet.bindProperty("driveway", toKey: "theDriveway")
        return propertySet
    }

    override func bsAwakeFromPropertyInjection() {
        garage!.empty = true
    }

    @objc init(address: SwiftAddress) {
        self.address = address
    }
}

class SwiftTennisCourt : NSObject {}

class SwiftMansion : SwiftHouse {
    @objc var tennisCourt: SwiftTennisCourt!

    class override func bsProperties() -> BSPropertySet {
        let propertySet = BSPropertySet(with: self, propertyNamesArray: ["tennisCourt"])
        propertySet.bindProperty("driveway", toKey: "10 car driveway")
        return propertySet
    }
}

class SwiftClassWithFactoryMethod : NSObject {
    @objc var foo: String
    @objc var bar: String

    @objc override static func bsCreate(withArgs args: [Any], injector: BSInjector) -> Any {
        return SwiftClassWithFactoryMethod(foo: args[0] as! String, bar: injector.getInstance("bar") as! String)
    }

    @objc init(foo: String, bar: String) {
        self.foo = foo
        self.bar = bar
    }
}
