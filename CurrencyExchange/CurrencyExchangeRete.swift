//
//  CurrencyExchangeRete.swift
//  CurrencyExchange
//
//  Created by 권석기 on 6/4/25.
//

import Foundation

struct CurrencyExchangeRateResponse: Decodable {
    let code: Int
    let message: String
    let data: String
}
