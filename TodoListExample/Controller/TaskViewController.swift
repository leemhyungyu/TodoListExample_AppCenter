//
//  ViewController.swift
//  TodoListExample
//
//  Created by 임현규 on 2022/04/07.
//

import UIKit

var deleteIndex: Int = 0

class TaskViewController: UIViewController {

    var sectionHeader : [String] = ["Today", "Upcoming"]
    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var isTodayBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    @IBOutlet weak var inputViewBottom: NSLayoutConstraint!
    
    let todoListViewModel = TodoViewModel()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NotificationCenter에 옵저버 등록
        // 옵저버들이 이벤트를 관찰했을 때 adjustInputView메소드 실행
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillShowNotification, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(adjustInputView), name: UIResponder.keyboardWillHideNotification, object: nil)
        
        setup()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        todoListViewModel.loadTasks()
        taskTableView.reloadData()
        
    }
    
    @IBAction func isTodayBtnClicked(_ sender: UIButton) {
        isTodayBtn.isSelected = !isTodayBtn.isSelected
    }
    
    // 빈 공간 클릭시 키보드를 내려줌
    @IBAction func tapBG(_ sender: Any) {
        // 현재 키보드가 올라와있는 텍스트 필드의 상태를 포기하게 만듬
        inputTextField.resignFirstResponder()
    }
    
    // add버튼을 클릭했을때 실행되는 함수(
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
    
    // textField를 눌렀을 때 키보드가 올라가거나 내려갈때 실행되는 함수
    // Notification -> NotificationCenter를 통해 정보를 저장하기 위한 구조체.
    // Notification.name -> 전달하고자하는 notification의 이름
    // Notification.userInfo ->
    @objc private func adjustInputView(noti: Notification) {
        
        // 옵저버로부터 받아온 정보가 있는지 확인
        guard let userInfo = noti.userInfo else { return }
        
        // userInfo 딕셔너리에 UIResponder.keyboardFrameEndUserInfoKey 키 값을 입력하게 되면
        // 반환하는 값은 키보드의 사이즈임
        guard let keyboardFrame = (userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue else { return }
        
        // 키보드가 올라오는 이벤트일 경우
        if noti.name == UIResponder.keyboardWillShowNotification {
            let adjustmentHeight = keyboardFrame.height - view.safeAreaInsets.bottom
            inputViewBottom.constant = adjustmentHeight
        } else { // 키보드가 내려가는 이벤트일 경우
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
        
        // today
        if indexPath.section == 0 {
            todo = todoListViewModel.todayTodos[indexPath.row]
        } else { // upcomming
            todo = todoListViewModel.upcompingTodos[indexPath.row]
        }
        cell.updateUI(todo: todo)
        
        // isDone값이 인자로 들어와서 실행
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
