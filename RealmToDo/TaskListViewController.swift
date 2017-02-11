import Foundation
import RealmSwift
import UIKit

class TaskListViewController: UIViewController {
    
    let taskRepository = TaskRepository.sharedInstance
    
    var taskList: [Task] {
        get {
            return taskRepository.findAll()
        }
    }
    
    let tableView: UITableView = UITableView()
    let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationBar()
        layout()
        
        self.tableView.dataSource = self
        self.tableView.delegate = self
    }
    func navigationBar() {
        let addButton: UIBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(TaskListViewController.showCreateView))
        self.navigationItem.rightBarButtonItem = addButton
    }
    
    func layout() {
        self.view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: self.view.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        tableView.widthAnchor.constraint(equalTo: self.view.widthAnchor).isActive = true
    }
    
    func showCreateView() {
        let alert = UIAlertController(title: "Add Todo", message: nil, preferredStyle: .alert)
        alert.addTextField(){textField in
            textField.placeholder = "task name"
            textField.returnKeyType = .done
        }
        let defaultAction = UIAlertAction(title: "Done", style: .default) {[unowned self] action in
            let textFields =  alert.textFields as Array<UITextField>?
            if let fields = textFields {
                let textField = fields[0]
                let task = Task()
                task.name = textField.text!
                self.taskRepository.add(task)
                textField.text = nil
                self.tableView.reloadData()            }
        }
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}

extension TaskListViewController : UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let task = taskList[(indexPath as NSIndexPath).row]
        return TaskTableViewCell(style: .default, reuseIdentifier: nil, task: task, delegate: self)
    }
}

extension TaskListViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt: IndexPath) {
        print(didSelectRowAt.row)
    }
}

extension TaskListViewController : TaskTableViewCellDelegate {
    func updateTodo(_ task: Task) {
        let alert = UIAlertController(title: "Edit", message: nil, preferredStyle: .alert)
        alert.addTextField(){ textField in
            textField.placeholder = "task name"
            textField.text = task.name
            textField.returnKeyType = .done
        }
        let defaultAction = UIAlertAction(title: "Done", style: .default) {[unowned self] action in
            let textFields =  alert.textFields as Array<UITextField>?
            if let fields = textFields {
                let textField = fields[0]
                self.taskRepository.transaction {
                    task.name = textField.text!
                }
                textField.text = nil
                self.tableView.reloadData()            }
        }
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    func removeTodo(_ task: Task) {
        let alert = UIAlertController(title: nil, message: "Are you sure that you want to delete?", preferredStyle: .alert)
        let defaultAction = UIAlertAction(title: "Delete", style: .default) {
            [unowned self] action in
            self.taskRepository.delete(task)
            self.tableView.reloadData()
        }
        alert.addAction(defaultAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
}
