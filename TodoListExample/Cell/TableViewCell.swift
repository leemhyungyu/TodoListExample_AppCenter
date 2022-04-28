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
    
    var doneButtonTapHandler: ((Bool) -> Void)?
    var deleteButtonTapHandler: (() -> Void)?
    
    @IBAction func checkBtnClicked(_ sender: UIButton) {
        CheckBtn.isSelected = !CheckBtn.isSelected
        let isDone = CheckBtn.isSelected
        StraigthView.isHidden = isDone
        DeleteBtn.isHidden = isDone

        
        doneButtonTapHandler?(isDone)
    }
    
    @IBAction func deleteBtnClicked(_ sender: UIButton) {
        
        deleteButtonTapHandler?()
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
    }
    
    func updateUI(todo: Todo) {
        CheckBtn.isSelected = todo.isDone
        ListLabel.text = todo.detail
        DeleteBtn.isHidden = !todo.isDone
        StraigthView.isHidden = !todo.isDone
    }
}
