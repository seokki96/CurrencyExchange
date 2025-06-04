//
//  CurrencyExchangeViewModel.swift
//  CurrencyExchange
//
//  Created by 권석기 on 6/4/25.
//

import Foundation

class CurrencyExchangeViewModel: ObservableObject {
    @Published var exchangeRate: Double = 0.0
    @Published var fromAmount: Double = 0.0
    @Published var toAmount: Double = 0.0
    @Published var errorMessage: String?
    
    private let currencyExchangeService: CurrencyExchangeServiceProtocol
    
    init(currencyExchangeService: CurrencyExchangeServiceProtocol) {
        self.currencyExchangeService = currencyExchangeService
        self.fetchExchangeRate()
    }
    
    func fetchExchangeRate() {
        currencyExchangeService.fetchCurrencyExchangeRate { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let result):
                DispatchQueue.main.async {
                    self.exchangeRate = result
                }                
            case .failure(let error):
                if let errorMessage = (error as? NetworkError)?.errorMessage {
                    self.errorMessage = errorMessage
                }
            }
        }
    }
    
    func exchangeToKRW() {
        toAmount = fromAmount * exchangeRate
    }
    
    func exchangeToUSD() {
        fromAmount = toAmount / exchangeRate
    }
}
