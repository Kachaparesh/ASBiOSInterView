//
//  ViewController.swift
//  ASBInterviewExercise
//
//  Created by ASB on 29/07/21.
//

import UIKit

class ViewController: UIViewController {
    
    private var viewModel: TransactionsViewModel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var progressBar: UIProgressView!
    private let refreshControl = UIRefreshControl()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepareRefreshControl()
        viewModelCall()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if(viewModel.getTransactionsCount() == 0) {
            loadTransactions()
        }
    }
    
    fileprivate func viewModelCall() {
        viewModel = TransactionsViewModel()
        viewModel.delegate = self
    }
    
    fileprivate func prepareRefreshControl() {
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(loadTransactions), for: .valueChanged)
        tableView.refreshControl = refreshControl
        tableView.estimatedRowHeight = 80
        tableView.rowHeight = UITableView.automaticDimension
    }
    
    @objc func loadTransactions(){
        progressBar.isHidden = false
        progressBar.observedProgress = viewModel.loadData()
    }
    
    @IBAction func sortTransactionTapped(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Sort transactions", message: "Please Select following order", preferredStyle: .actionSheet)
        let ascendingSortButton = UIAlertAction(title: "Newest first", style: .default , handler:{ [weak self] (UIAlertAction)in
            self?.viewModel.updateSorting()
            self?.tableView.reloadData()
        })
        
        let descendingSortButton = UIAlertAction(title: "Oldest first", style: .default , handler:{ [weak self] (UIAlertAction)in
            self?.viewModel.updateSorting()
            self?.tableView.reloadData()
        })
        ascendingSortButton.isEnabled = viewModel.getSortingOption()
        descendingSortButton.isEnabled = !viewModel.getSortingOption()
        
        alert.addAction(ascendingSortButton)
        
        alert.addAction(descendingSortButton)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        
        if let popoverController = alert.popoverPresentationController {
            popoverController.barButtonItem = sender
        }
        
        self.present(alert, animated: true, completion: {
        })
    }
    
    override func shouldPerformSegue(withIdentifier identifier: String, sender: Any?) -> Bool {
        viewModel.cancelAllCalls()
        return true
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showTransactionDetail")
        {
            let detailVc = segue.destination as! DetailViewController
            detailVc.transaction = viewModel.getTransactionsAtIndex(self.tableView.indexPathForSelectedRow!.row) 
        }
    }
}

extension ViewController: DataLoaderDelegate {
    func onDataLoadingFailed(_ error: Error) {
        showFailureAlert(with: error)
    }
    
    func onDataLoad() {
        finishProgress()
    }
    
    func finishProgress(){
        refreshControl.endRefreshing()
        tableView.reloadData()
        Timer.scheduledTimer(withTimeInterval: 1.0, repeats: false) { [weak self] timer in
            self?.progressBar.isHidden = true
            self?.progressBar.setProgress(0, animated: false)
            timer.invalidate()
        }
    }
    
    func showFailureAlert(with error: Error) {
        let alert = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        
        alert.addAction(UIAlertAction(title: "Dismiss", style: .cancel, handler:{ (UIAlertAction)in
        }))
        
        present(alert, animated: true, completion: {
        })
    }
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getTransactionsCount()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! TransactionTableViewCell
        cell.prepareCellUI(transaction: viewModel.getTransactionsAtIndex(indexPath.row))
        return cell
    }
}
