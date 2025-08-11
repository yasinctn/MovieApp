//
//  NetworkClient.swift
//  MovieApp
//
//  Created by Yasin Çetin on 8.08.2025.
//

import Foundation
import Alamofire
import PromiseKit

protocol NetworkClientProtocol {
    func request<T: Decodable>(endpoint: APIEndpoint) -> Promise<T>
}

final class NetworkClient: NetworkClientProtocol {

    func request<T: Decodable>(endpoint: APIEndpoint) -> Promise<T> {
        return Promise { seal in
            do {
                let dataRequest = try endpoint.asAFRequest()
                dataRequest
                    .validate()
                    .responseDecodable(of: T.self, decoder: JSONDecoder()) { response in
                        switch response.result {
                        case .success(let decoded):
                            seal.fulfill(decoded)
                        case .failure(let error):
                            seal.reject(error)
                        }
                    }
            } catch {
                seal.reject(error)
            }
        }
    }
}
