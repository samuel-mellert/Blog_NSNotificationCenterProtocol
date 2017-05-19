import Foundation

// MARK: - Notifier Protocol
public protocol Notifier {
    
    associatedtype Notification: RawRepresentable
    
}

// MARK: - Notifier base implementation
public extension Notifier where Notification.RawValue == String {
    
    // MARK: Calculated notification name
    private static func notificationName(for notification: Notification) -> NSNotification.Name {
        return NSNotification.Name(rawValue: "\(self).\(notification.rawValue)")
    }
    
    // MARK: Add observer
    static func addObserver(_ observer: AnyObject, selector: Selector, notification: Notification) {
        let name = notificationName(for: notification)
        
        NotificationCenter.default.addObserver(observer, selector: selector, name: name, object: nil)
    }
    
    // MARK: Post notification
    static func postNotification(_ notification: Notification, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
        let name = notificationName(for: notification)
        
        NotificationCenter.default.post(name: name, object: object, userInfo: userInfo)
    }
    
    func postNotification(_ notification: Notification, object: AnyObject? = nil, userInfo: [String : AnyObject]? = nil) {
        Self.postNotification(notification, object: object, userInfo: userInfo)
    }
    
    // MARK: Remove observer
    static func removeObserver(_ observer: Any, notification: Notification? = nil) {
        if let notification = notification {
            NotificationCenter.default.removeObserver(observer, name: notificationName(for: notification), object: nil)
        } else {
            NotificationCenter.default.removeObserver(observer)
        }
    }
    
}


// MARK: - Example
class Barista: Notifier {
    
    enum Notification: String {
        case makeCoffee
    }
    
}

extension Selector {
    
    static let makeCoffeeNotification = #selector(Customer.drink(_:))
    
}

class Customer {
    
    @objc func drink(_ notification: NSNotification) {
        print("Mmm... Coffee")
    }
    
}


let customer = Customer()

Barista.addObserver(customer, selector: .makeCoffeeNotification, notification: .makeCoffee)

Barista.postNotification(.makeCoffee)
// prints: Mmm... Coffee

Barista.removeObserver(customer, notification: .makeCoffee)



