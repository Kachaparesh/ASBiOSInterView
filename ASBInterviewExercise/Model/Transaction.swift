//
//  Transaction.swift
//  ASBInterviewExercise
//
//  Created by Paresh Kacha on 1/08/22.
//

import Foundation

struct TransactionElement: Decodable {
//    Decodable because we are sending any change back to server
    let id: Int
    let transactionDate, summary: String
    let debit, credit: Double
    
    func getShortFormattedDate() -> String{
        return DateHelper.shortDateFormate(transactionDate)
    }
    
    func getFullFormattedDate() -> String{
        return DateHelper.fullDateFormate(transactionDate)
    }
}

typealias Transaction = [TransactionElement]
