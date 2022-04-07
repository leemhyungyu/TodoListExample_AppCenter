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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
