//
//  ViewController.swift
//  TodoListExample
//
//  Created by 임현규 on 2022/04/07.
//

import UIKit

class TaskViewController: UIViewController {

    var dayHistory = [String]()
    var todayList = ["인설실 과제하기", "데통 과제하기", "없서"]
    var nextList = ["영화보기", "운동하기", "게임하기"]
    var sectionHeader : [String] = ["Today", "Upcoming"]

    
    @IBOutlet weak var taskTableView: UITableView!
    @IBOutlet weak var inputTextField: UITextField!
    @IBOutlet weak var isTodayBtn: UIButton!
    @IBOutlet weak var addBtn: UIButton!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
    }
    
    @IBAction func isTodayBtnClicked(_ sender: UIButton) {
        isTodayBtn.isSelected = !isTodayBtn.isSelected
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
    
    func loadList() {
        
        guard let savedTodayList = UserDefaults.standard.object(forKey: "todayList") as? [String] else { return }
        
        guard let savedNextList = UserDefaults.standard.object(forKey: "nextList") as? [String] else { return }
        
        todayList = savedTodayList
        nextList = savedNextList
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
            return todayList.count
        } else {
            return nextList.count
        }
    }
    
    // cell에 대한 정보
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        
        switch indexPath.section {
        case 0:
            cell.ListLabel.text = todayList[indexPath.row]
        case 1:
            cell.ListLabel.text = nextList[indexPath.row]
        
        default:
            return UITableViewCell()
        }
        
        cell.ListLabel.sizeToFit()
        cell.DeleteBtn.addTarget(self, action: #selector(reload), for: .touchUpInside)
        
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
    
    @objc func reload() {
        loadList()
        self.taskTableView.reloadData()
    }
    
}

class TableViewCell: UITableViewCell {

    @IBOutlet weak var CheckBtn: UIButton!
    @IBOutlet weak var DeleteBtn: UIButton!
    @IBOutlet weak var ListLabel: UILabel!
    @IBOutlet weak var StraigthView: UIView!
    
  
    @IBAction func checkBtnClicked(_ sender: UIButton) {
        let size = CGRect(x: 60, y: 30, width: ListLabel.frame.width, height: 2) // 나중에 오토레이아웃 설정
        self.StraigthView.frame = size
        
        CheckBtn.isSelected = !CheckBtn.isSelected
        let isDone = CheckBtn.isSelected

        if isDone {
            ListLabel.textColor = .gray
            DeleteBtn.isHidden = false
            StraigthView.isHidden = false
        } else {
            ListLabel.textColor = .black
            DeleteBtn.isHidden = true
            StraigthView.isHidden = true
        }
    }
    
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        
        guard var todayList = UserDefaults.standard.object(forKey: "todayList") as? [String] else { return }
        guard var nextList = UserDefaults.standard.object(forKey: "nextList") as? [String] else { return }
        guard let text = ListLabel.text else { return }
        
        if todayList.contains(text) {
            if let index = todayList.firstIndex(of: text) {
                todayList.remove(at: index)
            }
        } else {
            if let index = nextList.firstIndex(of: text) {
                nextList.remove(at: index)
            }
        }
        
        UserDefaults.standard.setValue(todayList, forKey: "todayList")
        UserDefaults.standard.setValue(nextList, forKey: "nextList")
    }
    
    @IBAction func checkBtnCilcked(_ sender: UIButton) {
        //CheckBtn.isHidden = true
        
    }
    override func awakeFromNib() {
        super.awakeFromNib()
        setUp()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}

extension TableViewCell {
    func setUp() {
        DeleteBtn.isHidden = true
        StraigthView.isHidden = true
        self.selectionStyle = .none
        self.StraigthView.isHidden = true
    }
}
