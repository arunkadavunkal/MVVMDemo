//
//  ViewController.swift
//  MVVMDemo
//
//  Created by arun.kadavunkal on 20/07/2023.
//

import UIKit
import Combine

class ProductListViewController: UIViewController {

    @IBOutlet weak var productTableView: UITableView!

    private var cancellables = Set<AnyCancellable>()
    private let viewModel: ProductListViewModelType = ProductListViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupUI()
        self.fetchProductsAndSink()
    }

    private func setupUI() {
        self.title = ProductListConstants.productListVCTitle
    }

    private func fetchProductsAndSink() {
        self.viewModel.fetchProducts()
        self.viewModel.fetchStatusPublisher
            .sink { fetchStatus in
                switch fetchStatus {
                case .processing:
                    //Show a loader here
                    break
                case .succes:
                    self.productTableView.reloadData()
                case .error(let errorMessage):
                    print(errorMessage)
                    //show an alert showing error message
                    break
                }
        }
            .store(in: &cancellables)
    }
}

// MARK: UITableViewDataSource
extension ProductListViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.products.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: ProductListConstants.productListTableCellIdentifier,
                                                 for: indexPath)
        cell.textLabel?.text = viewModel.products[indexPath.row].productName
        return cell
    }
}

