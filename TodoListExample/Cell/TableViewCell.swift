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
    }
}
