import UIKit

@objc protocol TaskTableViewCellDelegate {
    func updateTodo(_ task: Task)
    func removeTodo(_ task: Task)
}

class TaskTableViewCell : UITableViewCell {
    
    let task: Task
    unowned let delegate: TaskTableViewCellDelegate
    var haveButtonsDisplayed = false
    
    required init(coder: NSCoder) {
        fatalError("NSCoding not supported")
    }
    
    init(style: UITableViewCellStyle, reuseIdentifier: String!, task: Task, delegate: TaskTableViewCellDelegate) {
        self.task = task
        self.delegate = delegate
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        textLabel?.text = task.name
        
        self.selectionStyle = .none
        
        self.createView()
        
        let swipeRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(TaskTableViewCell.showDeleteButton))
        swipeRecognizer.direction = .left
        self.contentView.addGestureRecognizer(swipeRecognizer)
        
        self.contentView.addGestureRecognizer(UISwipeGestureRecognizer(target: self, action: #selector(TaskTableViewCell.hideDeleteButton)))
    }
    
    func createView() {
        let origin  = self.frame.origin
        let size    = self.frame.size
        
        self.contentView.backgroundColor = UIColor.white
        
        let updateButton = UIButton(type: .system) as UIButton
        updateButton.frame = CGRect(x: size.width - 100, y: origin.y, width: 50, height: size.height)
        updateButton.backgroundColor = UIColor.lightGray
        updateButton.setTitle("Edit", for: UIControlState())
        updateButton.setTitleColor(UIColor.white, for: UIControlState())
        updateButton.addTarget(self, action: #selector(TaskTableViewCell.updateTodo), for: .touchUpInside)
        
        let removeButton = UIButton(type: .system) as UIButton
        removeButton.frame = CGRect(x: size.width - 50, y: origin.y, width: 50, height: size.height)
        removeButton.backgroundColor = UIColor.red
        removeButton.setTitle("Delete", for: UIControlState())
        removeButton.setTitleColor(UIColor.white, for: UIControlState())
        removeButton.addTarget(self, action: #selector(TaskTableViewCell.removeTodo), for: .touchUpInside)
        
        self.backgroundView = UIView(frame: self.bounds)
        self.backgroundView?.addSubview(updateButton)
        self.backgroundView?.addSubview(removeButton)
    }
    
    func updateTodo() {
        delegate.updateTodo(self.task)
    }
    
    func removeTodo() {
        delegate.removeTodo(self.task)
    }
    
    func showDeleteButton() {
        if !self.haveButtonsDisplayed {
            UIView.animate(withDuration: 0.1, animations: {
                let size   = self.contentView.frame.size
                let origin = self.contentView.frame.origin
                
                self.contentView.frame = CGRect(x: origin.x - 100, y:origin.y, width:size.width, height:size.height)
                
                }, completion: { completed in self.haveButtonsDisplayed = true })
        }
    }
    
    func hideDeleteButton() {
        if self.haveButtonsDisplayed {
            UIView.animate(withDuration: 0.1, animations: {
                let size   = self.contentView.frame.size
                let origin = self.contentView.frame.origin
                
                self.contentView.frame = CGRect(x: origin.x + 100, y:origin.y, width:size.width, height:size.height)
                
                }, completion: { completed in self.haveButtonsDisplayed = false }) 
        }
    }
}
