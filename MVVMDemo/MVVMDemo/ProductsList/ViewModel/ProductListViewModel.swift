//
//  ProductListViewModel.swift
//  MVVMDemo
//
//  Created by arun.kadavunkal on 20/07/2023.
//

import Foundation
import Combine

protocol ProductListViewModelType {
    var fetchStatusPublisher: Published<FetchStatus>.Publisher { get }
    var products: [Product] { get set }
    func fetchProducts()
}

final class ProductListViewModel: ProductListViewModelType {

    var cancellables = Set<AnyCancellable>()
    @Published var fetchStatus: FetchStatus = .processing
    var fetchStatusPublisher: Published<FetchStatus>.Publisher { $fetchStatus }
    let webservice: WebServiceManagerType = WebServiceManager()
    var products: [Product] = []

    func fetchProducts() {
        fetchStatus = .processing
        webservice.request(endPoint: EndPoint.products, responseType: ProductResponse.self)
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .failure(let error):
                    self?.fetchStatus = .error(error.localizedDescription)
                case .finished:
                    self?.fetchStatus = .succes
                }
            } receiveValue: { [weak self] productResponse in
                self?.products = productResponse.products
            }
            .store(in: &cancellables)
    }
}
