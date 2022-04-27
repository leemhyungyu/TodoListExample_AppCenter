//
//  TableViewCell.swift
//  TodoListExample
//
//  Created by 임현규 on 2022/04/07.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var CheckBtn: UIButton!
    @IBOutlet weak var DeleteBtn: UIButton!
    @IBOutlet weak var ListLabel: UILabel!
    @IBOutlet weak var StraigthView: UIView!
    
  
    @IBAction func checkBtnClicked(_ sender: UIButton) {
        let size = CGRect(x: 60, y: 30, width: ListLabel.frame.width, height: 2) // 나중에 오토레이아웃 설정
        self.StraigthView.isHidden = false
        self.StraigthView.frame = size
    }
    
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        
        guard var todayList = UserDefaults.standard.object(forKey: "todayList") as? [String] else { return }
        
        guard var text = ListLabel.text as? String else { return }
        print(text)
        
        if var index = todayList.firstIndex(of: text) {
            print(index)
            todayList.remove(at: index)
        }
        UserDefaults.standard.setValue(todayList, forKey: "todayList")
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
        self.selectionStyle = .none
        self.StraigthView.isHidden = true
    }
}
