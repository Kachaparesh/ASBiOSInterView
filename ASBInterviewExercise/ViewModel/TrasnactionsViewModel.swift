//
//  TrasnactionsViewModel.swift
//  ASBInterviewExercise
//
//  Created by Paresh Kacha on 2/08/22.
//

import Foundation
protocol DataLoaderDelegate {
    func onDataLoad()
    func onDataLoadingFailed(_ error: Error)
}
class TransactionsViewModel {
    private var apiClient = DIManager.shared.resolve(RestClient.self)
    private var transactions = Transaction()
    private var isOldestFirst = false
    var delegate: DataLoaderDelegate?
    @objc func loadData() -> Progress?{
        return apiClient?.prepareAndCallApi(type: Transaction.self, completion: { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                    case .success(let results):
                        self?.transactions = results
                        self?.sortTransactions()
                    case .failure(let error):
                        self?.delegate?.onDataLoadingFailed(error)
                }
                self?.delegate?.onDataLoad()
            }
        })?.progress
    }
    
    func sortTransactions() {
        if(isOldestFirst) {
            transactions = (transactions
                .map { return ($0, DateHelper.parsingFormatter.date(from: $0.transactionDate)!) }
                .sorted { $0.1 < $1.1 }
                .map(\.0))
        }
        else {
            transactions = (transactions
                .map { return ($0, DateHelper.parsingFormatter.date(from: $0.transactionDate)!) }
                .sorted { $0.1 > $1.1 }
                .map(\.0))
        }
    }
    
    func updateSorting(){
        isOldestFirst = !isOldestFirst
        sortTransactions()
    }
    
    func getSortingOption() -> Bool {
        return self.isOldestFirst
    }
    
    func getTransactionsCount() -> Int {
        return transactions.count
    }
    
    func getTransactionsAtIndex(_ index: Int) -> TransactionElement {
        return transactions[index]
    }
    
    func cancelAllCalls(){
        apiClient?.cancelAllTasks()
    }
}
