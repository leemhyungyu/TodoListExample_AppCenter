//
//  ViewController.swift
//  TodoListExample
//
//  Created by 임현규 on 2022/04/07.
//

import UIKit

class TaskViewController: UIViewController {

    var dayHistory = [String]()
    var todayList = ["123", "456", "789"]
    var nextList = ["abc", "def", "ghi"]
    var sectionHeader : [String] = ["Today", "Upcoming"]

    
    @IBOutlet weak var taskTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        
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

// MARK: - UITableViewDelegate
extension TaskViewController {
    
    func loadList() {
        
        guard let saveList = UserDefaults.standard.object(forKey: "todayList") as? [String] else { return }
        
        todayList = saveList
    }
}
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
        return todayList.count
    }
    
    // cell에 대한 정보
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as? TableViewCell else { return UITableViewCell() }
        cell.ListLabel.text = todayList[indexPath.row]
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

