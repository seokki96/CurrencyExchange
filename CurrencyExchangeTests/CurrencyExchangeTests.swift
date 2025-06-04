//
//  CurrencyExchangeTests.swift
//  CurrencyExchangeTests
//
//  Created by 권석기 on 6/4/25.
//

import XCTest
@testable import CurrencyExchange

final class CurrencyExchangeTests: XCTestCase {
    var viewModel: CurrencyExchangeViewModel!
    let currencyExchangeService = StubCurrencyExchangeService(exchangeRate: 1450.0)
    
    override func setUpWithError() throws {
        viewModel = CurrencyExchangeViewModel(currencyExchangeService: currencyExchangeService)
    }

    override func tearDownWithError() throws {
        viewModel = nil
    }

    func test_환율정보를_받아오면_환율이_정확히_반영되는가() throws {
        let expectation = XCTestExpectation(description: "Stub객체에서 환율정보를 받아오는 요청")
        // Given - 서버로부터 환율 정보를 받아옴
        viewModel.fetchExchangeRate()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) { [weak self] in
            guard let self = self else { return }
            XCTAssertEqual(viewModel.exchangeRate, 1450.0)
            expectation.fulfill()
        }
        wait(for: [expectation], timeout: 2.0)
        
        // When - 받아온 환율정보로 환전 금액을 입력
        let fromAmount = 10.0
        viewModel.fromAmount = 10.0
        viewModel.exchangeToKRW()
        
        // Then - 실제 환전값과 기대값이 일치하는지 검증
        XCTAssertEqual(fromAmount * 1450.0, viewModel.toAmount)
    }
    
    func test_환율정보API_요청시_정상적으로_환율값을_받아오는가() throws {
        let expectation = XCTestExpectation(description: "실제 서버 API로 환율 정보를 요청")
        currencyExchangeService.fetchCurrencyExchangeRate { result in
            switch result {
            case .success(let result):
                XCTAssertTrue(true)
            case .failure(let failure):
                XCTFail(failure.localizedDescription)
            }
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 2.0)
    }

    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
