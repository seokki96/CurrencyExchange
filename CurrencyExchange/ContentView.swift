//
//  ContentView.swift
//  CurrencyExchange
//
//  Created by 권석기 on 6/4/25.
//

import SwiftUI

enum Field {
    case fromAmount
    case toAmount
}

struct ContentView: View {
    @StateObject var viewModel: CurrencyExchangeViewModel
    @FocusState var field: Field?
    @Environment(\.locale) var locale
    
    var body: some View {
        VStack {
            Text("current exchange rate")
                .font(.title)
            VStack {
                if viewModel.exchangeRate == 0 {
                    ProgressView()
                } else {
                    Text("\(viewModel.exchangeRate)")
                }
            }
            .padding(10)
            .fontWeight(.bold)
            .background(.orange)
            .foregroundStyle(.white)
            .cornerRadius(4)
            Text("🇺🇸 USD")
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("USD", value: $viewModel.fromAmount, format: .currency(code: "USD"))
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .focused($field, equals: .fromAmount)
            Text("🇰🇷 KRW")
                .frame(maxWidth: .infinity, alignment: .leading)
            TextField("KRW", value: $viewModel.toAmount, format: .currency(code: "KRW"))
                .keyboardType(.decimalPad)
                .textFieldStyle(.roundedBorder)
                .focused($field, equals: .toAmount)
        }
        .padding()
        .onChange(of: viewModel.fromAmount) { _ in
            if field == .toAmount { return }
            viewModel.exchangeToKRW()
        }
        .onChange(of: viewModel.toAmount) { _ in
            if field == .fromAmount { return }
            viewModel.exchangeToUSD()
        }
        .overlay {
            if let errorMessage = viewModel.errorMessage {
                ZStack {
                    Color.clear
                    VStack(spacing: 20) {
                        Image(systemName: "globe")
                            .font(.title)
                        Text(errorMessage)
                            .foregroundColor(.gray)
                    }
                }
                .background(.ultraThinMaterial)
                .frame(height: UIScreen.main.bounds.height)
            }
        }
    }
}

#Preview {
    ContentView(viewModel: CurrencyExchangeViewModel(currencyExchangeService: DefaultCurrencyExchangeService()))
}
