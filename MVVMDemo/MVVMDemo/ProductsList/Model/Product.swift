//
//  Product.swift
//  MVVMDemo
//
//  Created by arun.kadavunkal on 20/07/2023.
//

import Foundation

struct ProductResponse: Decodable {
    let products: [Product]
}

struct Product: Decodable{
    let id: String
    let productName: String
}
