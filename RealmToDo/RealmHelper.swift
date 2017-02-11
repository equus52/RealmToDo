import Foundation
import RealmSwift

class RealmHelper {
    
    static func removeDB() {
        do {
            let defaultPath: URL = Realm.Configuration.defaultConfiguration.fileURL!
            try FileManager.default.removeItem(at: defaultPath)
            print("removed realm DB")
        } catch {
            print(error)
        }
    }
}
