//
//  NetworkClient.swift
//  MovieApp
//
//  Created by Yasin Çetin on 8.08.2025.
//

import Foundation
import Alamofire

protocol NetworkClientProtocol {
    func request<T: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<T, Error>) -> Void)
}

final class NetworkClient: NetworkClientProtocol {
    func request<T: Decodable>(endpoint: APIEndpoint, completion: @escaping (Result<T, Error>) -> Void) {
        do {
            let request = try endpoint.asAFRequest()
            request.responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let decoded):
                    completion(.success(decoded))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        } catch {
            completion(.failure(error))
        }
    }
}
