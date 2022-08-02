//
//  DetailViewController.swift
//  ASBInterviewExercise
//
//  Created by Paresh Kacha on 2/08/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    var transaction: TransactionElement!
    @IBOutlet weak var idValue: UILabel!
    @IBOutlet weak var summaryValue: UILabel!
    @IBOutlet weak var transactionDateValue: UILabel!
    @IBOutlet weak var transactionType: UILabel!
    @IBOutlet weak var amountValue: UILabel!
    @IBOutlet weak var gstValue: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        idValue.isAccessibilityElement = true
        summaryValue.isAccessibilityElement = true
        transactionDateValue.isAccessibilityElement = true
        transactionType.isAccessibilityElement = true
        gstValue.isAccessibilityElement = true
        
        idValue.text = "\(transaction.id)"
        summaryValue.text = transaction.summary
        transactionDateValue.text = transaction.getFullFormattedDate()
        
        if(transaction.debit > 0)
        {
            transactionType.text = "Debit"
            transactionType.textColor = .systemRed
            amountValue.textColor = .systemRed
            amountValue.text = "\(transaction.debit.formatted(.currency(code: "NZD")))"
            gstValue.text = "\((transaction.debit * 0.15).formatted(.currency(code: "NZD")))"
        }
        else
        {
            transactionType.text = "Credit"
            transactionType.textColor = .systemGreen
            amountValue.textColor = .systemGreen
            amountValue.text = "\(transaction.credit.formatted(.currency(code: "NZD")))"
            gstValue.text = "\((transaction.credit * 0.15).formatted(.currency(code: "NZD")))"
        }
    }
}
