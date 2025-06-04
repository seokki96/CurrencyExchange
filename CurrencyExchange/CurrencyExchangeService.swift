//
//  CurrencyExchangeService.swift
//  CurrencyExchange
//
//  Created by 권석기 on 6/4/25.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case decodingFailed
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            "유효하지 않은 URL 입니다."
        case .invalidResponse:
            "유효하지 않은 요청 또는 응답입니다."
        case .decodingFailed:
            "데이터를 디코딩하는데 문제가 발생했습니다."
        }
    }
}

protocol CurrencyExchangeServiceProtocol {
    func fetchCurrencyExchangeRate(_ completion: @escaping (Result<Double, Error>)->())
}

class DefaultCurrencyExchangeService: CurrencyExchangeServiceProtocol {
    func fetchCurrencyExchangeRate(_ completion: @escaping (Result<Double, Error>)->()) {
        guard let url = URL(string: "https://98107e2c-a68e-4e89-bacf-85f13c9a1652.mock.pstmn.io/money") else {
            completion(.failure(NetworkError.invalidURL))
            return
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        
        let session: URLSession = URLSession(configuration: .default)
        session.dataTask(with: request) { (data, response, error) in
            let successRange: Range = (200..<300)
            
            guard let data: Data = data,
                  error == nil
            else { return }
            
            if let response: HTTPURLResponse = response as? HTTPURLResponse{
                if successRange.contains(response.statusCode) {
                    do {
                        let result: CurrencyExchangeRateResponse = try JSONDecoder().decode(CurrencyExchangeRateResponse.self, from: data)
                        if let exchangeRate = Double(result.data.components(separatedBy: ",").joined()) {
                            completion(.success(exchangeRate))
                        } else {
                            completion(.failure(NetworkError.decodingFailed))
                        }
                        
                    } catch {
                        completion(.failure(error))
                    }
                    
                } else {
                    completion(.failure(NetworkError.invalidResponse))
                }
            }
            
        }.resume()
    }
}

class StubCurrencyExchangeService: CurrencyExchangeServiceProtocol {
    let exchangeRate: Double
    init(exchangeRate: Double) {
        self.exchangeRate = exchangeRate
    }
    func fetchCurrencyExchangeRate(_ completion: @escaping (Result<Double, Error>)->()) {
        completion(.success(exchangeRate))
    }
}
