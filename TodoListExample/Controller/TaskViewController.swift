//
//  ViewController.swift
//  TodoListExample
//
//  Created by 임현규 on 2022/04/07.
//

import UIKit

var deleteIndex: Int = 0

class TaskViewController: UIViewController {

    var dayHistory = [String]()
    var todayList = [String]()
    var nextList = [String]()
    var sectionHeader : [String] = ["Today", "Upcoming"]

    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var isTodayBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    
    let todoListViewModel = TodoViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setup()
        
    }
    
    @IBAction func isTodayBtnClicked(_ sender: UIButton) {
        isTodayBtn.isSelected = !isTodayBtn.isSelected
    }
    
    @IBAction func tapBG(_ sender: Any) {
        inputTextField.resignFirstResponder()
    }
    
    @IBAction func addBtnClicked(_ sender: UIButton) {
        
        guard let detail = inputTextField.text, detail.isEmpty == false else { return }
        
        let todo = TodoManager.shared.createTodo(detail: detail, isToday: isTodayBtn.isSelected)
        todoListViewModel.addTodo(todo)
        taskTableView.reloadData()
        inputTextField.text = ""
        isTodayBtn.isSelected = false
    }
}


extension TaskViewController {
    func setup() {
        
        UserDefaults.standard.setValue(todayList, forKey: "todayList")
        
        UserDefaults.standard.setValue(nextList, forKey: "nextList")
        
        taskTableView.delegate = self
        taskTableView.dataSource = self
        
        // taskTableView가 "TableViewCell"을 렌더링하게 설정
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        taskTableView.register(nibName, forCellReuseIdentifier: "todoCell")
        
        // cell 사이의 구분선 없애기
        taskTableView.separatorStyle = .none
        
        // footer 삭제.
        taskTableView.sectionFooterHeight = 0
    }
}

extension TaskViewController {
    
    @objc private func adjustInputView(noti: Notification) {
        guard let userInfo = noti.userInfo else { return }
        // [x] TODO: 키보드 높이에 따른 인풋뷰 위치 변경
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
        } else {
            inputViewBottom.constant = 0
        }
    }
}

// MARK: - UITableViewDelegate
extension TaskViewController: UITableViewDelegate {
    
    // cell 간격
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }
}
 
// MARK - UITableVIewDataSource
extension TaskViewController: UITableViewDataSource {
    
    // MARK - Cell
    
    // section마다의 cell개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if section == 0 {
            return todoListViewModel.todayTodos.count
        } else {
            return todoListViewModel.upcompingTodos.count
        }
    }
    
    
    
    // cell에 대한 정보
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        var todo: Todo
        
        if indexPath.section == 0 {
            todo = todoListViewModel.todayTodos[indexPath.row]
        } else {
            todo = todoListViewModel.upcompingTodos[indexPath.row]
        }
        cell.updateUI(todo: todo)
        cell.ListLabel.sizeToFit()
        
        cell.doneButtonTapHandler = { isDone in
            todo.isDone = isDone
            self.todoListViewModel.updateTodo(todo)
            self.taskTableView.reloadData()
        }
        
        cell.deleteButtonTapHandler = {
            self.todoListViewModel.deleteTodo(todo)
            self.taskTableView.reloadData()
        }
        
        return cell
    
    }
    
    // MARK - Section
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }

    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
 
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
       
        let myLabel = UILabel()
        myLabel.frame = CGRect(x: 12, y: 0, width: 330, height: 30)
        myLabel.font = UIFont.boldSystemFont(ofSize: 24)
        myLabel.text = sectionHeader[section]
        
        let headerView = UIView()
        headerView.addSubview(myLabel)
        return headerView
    }
}
