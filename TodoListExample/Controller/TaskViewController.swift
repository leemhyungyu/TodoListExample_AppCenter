//
//  ViewController.swift
//  TodoListExample
//
//  Created by 임현규 on 2022/04/07.
//

import UIKit

class TaskViewController: UIViewController {

    var todayList = [String]()
    var nextList = [String]()
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        tableView.delegate = self
        tableView.dataSource = self
        super.viewDidLoad()
        setup()
        
    }
}

extension TaskViewController {
    func setup() {
        let nibName = UINib(nibName: "TableViewCell", bundle: nil)
        tableView.register(nibName, forCellReuseIdentifier: "todoCell")
    }
}

// MARK: - UITableViewDelegate

extension TaskViewController: UITableViewDelegate {
    
    // cell 간격
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
 
// MARK - UITableVIewDataSource
extension TaskViewController: UITableViewDataSource {
    
    // section마다의 cell개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    // cell에 대한 정보
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! TableViewCell
        cell.ListLabel.text = "👻 Weekly iOS Meeting"
        cell.ListLabel.sizeToFit()
        
        return cell
    }
}

