import RxBlocking
import RxSwift
import RxTest
@testable import Weather
import UIKit
import XCTest

final class WeatherRepositoryTests: XCTestCase {

    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }

    func testGetWeatherForecastRequestsData() {
        let weatherServiceMock = WeatherServiceMock()
        let sut = WeatherRepositoryImpl(weatherService: weatherServiceMock)

        let expectation = expectation(description: "Should send data")

        sut.getWeatherForecasts(in: "paris", numberOfDays: 5).asObservable()
            .subscribe(
                onNext: { _ in
                    expectation.fulfill()
                },
                onError: { _ in
                    XCTFail("Should not happen")
                }
            )
            .disposed(by: disposeBag)

        XCTAssertTrue(weatherServiceMock.didCall)

        waitForExpectations(timeout: 0.5) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
    }
}
