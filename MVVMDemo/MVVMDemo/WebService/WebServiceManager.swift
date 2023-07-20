//
//  WebServiceManager.swift
//  MVVMDemo
//
//  Created by arun.kadavunkal on 20/07/2023.
//

import Foundation
import Combine

protocol WebServiceManagerType {
    func request<T: Decodable> (endPoint: EndPoint, responseType: T.Type) -> AnyPublisher<T, Error>
}

final class WebServiceManager: WebServiceManagerType {
    func request<T>(endPoint: EndPoint, responseType: T.Type) -> AnyPublisher<T, Error> where T : Decodable {
        guard let url = URL(string: APIConstants.baseURL + endPoint.rawValue) else {
            return Fail(error: CustomError.invalidURL).eraseToAnyPublisher()
        }

        return URLSession.shared.dataTaskPublisher(for: url)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw CustomError.badResponse
                }
                switch httpResponse.statusCode {
                case 200...299:
                    return data
                default:
                    throw CustomError.unkonwnError
                }
            }
            .decode(type: responseType.self, decoder: JSONDecoder())
            .eraseToAnyPublisher()
    }
}
