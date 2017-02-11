import Foundation
import RealmSwift

class Task: Object {
    dynamic var id: String = NSUUID().uuidString
    dynamic var name = String()
    
    override class func primaryKey() -> String? {
        return "id"
    }
}
