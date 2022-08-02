//
//  TransactionTableViewCell.swift
//  ASBInterviewExercise
//
//  Created by Paresh Kacha on 2/08/22.
//

import UIKit

class TransactionTableViewCell: UITableViewCell {
    @IBOutlet weak var summaryLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        summaryLabel.isAccessibilityElement = true
        dateLabel.isAccessibilityElement = true
        amountLabel.isAccessibilityElement = true
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    func prepareCellUI(transaction: TransactionElement){
        summaryLabel.text = transaction.summary
        dateLabel.text = transaction.getShortFormattedDate()
        amountLabel.textColor = transaction.debit > 0 ? .systemRed : .systemGreen
        let amount = transaction.debit > 0 ? transaction.debit : transaction.credit
        amountLabel.text = "\(amount.formatted(.currency(code: "NZD")))"
    }

}
