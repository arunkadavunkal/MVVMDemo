//
//  CustomError.swift
//  MVVMDemo
//
//  Created by arun.kadavunkal on 20/07/2023.
//

import Foundation

enum CustomError: LocalizedError {

    case invalidURL
    case badResponse
    case unkonwnError

    var errorDescription: String? {
        switch self {
        case .invalidURL,
                .badResponse,
                .unkonwnError:
            return "Something went wrong"
        }
    }
}
