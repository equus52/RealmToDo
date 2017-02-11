import Foundation
import UIKit
import RealmSwift

class TaskRepository {
    
    static let sharedInstance:TaskRepository = TaskRepository()
    
    let realm = try! Realm()
    
    private init(){
        refresh()
    }
    
    func findAll() -> [Task] {
        return realm.objects(Task.self).map{$0}
    }
    
    func add(_ task: Task) {
        try! realm.write { realm.add(task, update: true) }
        refresh()
    }
    
    func transaction(_ transactionBlock: () -> Void) {
        try! realm.write { transactionBlock() }
        refresh()
    }
    
    func delete(_ task: Task) {
        try! realm.write { realm.delete(task) }
        refresh()
    }
    
    private func refresh() {
        UIApplication.shared.applicationIconBadgeNumber = findAll().count
    }
}
