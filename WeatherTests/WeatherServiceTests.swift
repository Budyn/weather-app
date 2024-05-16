import RxBlocking
import RxSwift
import RxTest
@testable import Weather
import XCTest

final class WeatherServiceTests: XCTestCase {

    func testGetWeatherForecastWithCorruptedResponseReturnsError() {
        let disposeBag = DisposeBag()
        let errorToSend = DataFetchingError.decoding
        let dataFetcher = DataFetcherMock(response: "", errorToSend: errorToSend)
        
        let expectation = expectation(description: "Should send error")

        dataFetcher.data(for: buildFakeRequest()).asObservable()
            .subscribe(
                onNext: { (response: String) in
                    XCTFail("Should not happen")
                },
                onError: {
                    switch $0 as? DataFetchingError {
                    case .decoding:
                        expectation.fulfill()
                    default:
                        XCTFail("Wrong error type")
                    }
                }
            )
            .disposed(by: disposeBag)

        waitForExpectations(timeout: 1) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
    }
}

private func buildFakeRequest() -> URLRequest {
    let fakeURL = URL.documentsDirectory
    return URLRequest(url: fakeURL)
}
