import Foundation
import Blindside

class SwiftState : NSObject {}
class SwiftCity : NSObject {
    var population = 0
}

class SwiftGarage : NSObject {
    var empty = true
}

class SwiftDriveway : NSObject {}

class SwiftAddress : NSObject {
    var street: String
    var city: SwiftCity
    var state: SwiftState
    var zip: String

    static override func bsInitializer() -> BSInitializer {
        return BSInitializer(withClass: self, selector: "initWithStreet:city:state:zip:", argumentKeysArray: ["street", "city", "state", "zip"])
    }

    init(street: String, city: SwiftCity, state: SwiftState, zip: String) {
        self.street = street
        self.city = city
        self.state = state
        self.zip = zip
    }
}

class SwiftHouse : NSObject {
    var address: SwiftAddress
    var garage: SwiftGarage!
    var driveway: SwiftDriveway!
    weak var injector: BSInjector!

    static override func bsInitializer() -> BSInitializer {
        return BSInitializer(withClass: self, selector: "initWithAddress:", argumentKeysArray: [SwiftAddress.self])
    }

    class override func bsProperties() -> BSPropertySet {
        let propertySet = BSPropertySet(withClass: self, propertyNamesArray: ["garage", "driveway"])
        propertySet.bindProperty("driveway", toKey: "theDriveway")
        return propertySet
    }

    override func bsAwakeFromPropertyInjection() {
        garage!.empty = true
    }

    init(address: SwiftAddress) {
        self.address = address
    }
}

class SwiftTennisCourt : NSObject {}

class SwiftMansion : SwiftHouse {
    var tennisCourt: SwiftTennisCourt!

    class override func bsProperties() -> BSPropertySet {
        let propertySet = BSPropertySet(withClass: self, propertyNamesArray: ["tennisCourt"])
        propertySet.bindProperty("driveway", toKey: "10 car driveway")
        return propertySet
    }
}

class SwiftClassWithFactoryMethod : NSObject {
    var foo: String
    var bar: String

    static override func bsCreateWithArgs(args: [AnyObject], injector: BSInjector) -> AnyObject {
        return SwiftClassWithFactoryMethod(foo: args[0] as! String, bar: injector.getInstance("bar") as! String)
    }

    init(foo: String, bar: String) {
        self.foo = foo
        self.bar = bar
    }
}
