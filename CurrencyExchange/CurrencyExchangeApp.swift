//
//  CurrencyExchangeApp.swift
//  CurrencyExchange
//
//  Created by 권석기 on 6/4/25.
//

import SwiftUI

@main
struct CurrencyExchangeApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView(viewModel: CurrencyExchangeViewModel(
                currencyExchangeService: DefaultCurrencyExchangeService()
            ))
        }
    }
}
