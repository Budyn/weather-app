import RxBlocking
import RxSwift
import RxTest
@testable import Weather
import UIKit
import XCTest

final class HomeViewModelTests: XCTestCase {

    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }

    func testStateIsEmptyOnStart() {
        let weatherRepositoryMock = WeatherRepositoryMock(forecasts: [
            WeatherForecast(date: Date(), forecasts: [])
        ])
        let sut = HomeViewModelImpl(
            router: HomeRouter(navigationController: UINavigationController()),
            weatherRepository: weatherRepositoryMock
        )

        let expectation = expectation(description: "Should send initial state")

        XCTAssertFalse(weatherRepositoryMock.didCall)

        sut.state.asObservable().subscribe(
            onNext: { response in
                XCTAssertNotNil(response)
                XCTAssertTrue(response.weatherForecasts.isEmpty)
                XCTAssertTrue(response.weatherForecasts.isEmpty)
                expectation.fulfill()
            }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 0.5) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
    }

    func testRefreshWeatherForecastRequestsData() {
        let weatherRepositoryMock = WeatherRepositoryMock(forecasts: [
            WeatherForecast(date: Date(), forecasts: [])
        ])
        let sut = HomeViewModelImpl(
            router: HomeRouter(navigationController: UINavigationController()),
            weatherRepository: weatherRepositoryMock
        )

        let expectation = expectation(description: "Should refresh state")

        XCTAssertFalse(weatherRepositoryMock.didCall)

        sut.refreshWeatherForecast()

        XCTAssertTrue(weatherRepositoryMock.didCall)

        sut.state.asObservable().subscribe(
            onNext: { response in
                XCTAssertNotNil(response)
                XCTAssertFalse(response.weatherForecasts.isEmpty)
                expectation.fulfill()
            }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 0.5) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
    }

    func testRefreshWeatherForecastFindMidDayForecast() {
        var dateComponents = DateComponents()
        dateComponents.hour = 14
        let midDayDate = Calendar.current.date(from: dateComponents)!

        var morningDateComponents = DateComponents()
        morningDateComponents.hour = 6
        let morningDate = Calendar.current.date(from: morningDateComponents)!

        var eveningDateComponents = DateComponents()
        eveningDateComponents.hour = 21
        let eveningDate = Calendar.current.date(from: eveningDateComponents)!

        let weatherRepositoryMock = WeatherRepositoryMock(forecasts: [
            WeatherForecast(date: Date(), forecasts: [
                WeatherForecast.Forecast(
                    timestamp: midDayDate,
                    temperature: 1.0,
                    minTemperature: 1.0,
                    maxTemperature: 1.0,
                    pressure: 1.0,
                    humidity: 1.0,
                    conditionsDescription: "Good",
                    dayMinTemperature: 1.0,
                    dayMaxTemperature: 1.0
                ),
                WeatherForecast.Forecast(
                    timestamp: morningDate,
                    temperature: 1.0,
                    minTemperature: 1.0,
                    maxTemperature: 1.0,
                    pressure: 1.0,
                    humidity: 1.0,
                    conditionsDescription: "Good",
                    dayMinTemperature: 1.0,
                    dayMaxTemperature: 1.0
                ),
                WeatherForecast.Forecast(
                    timestamp: eveningDate,
                    temperature: 1.0,
                    minTemperature: 1.0,
                    maxTemperature: 1.0,
                    pressure: 1.0,
                    humidity: 1.0,
                    conditionsDescription: "Good",
                    dayMinTemperature: 1.0,
                    dayMaxTemperature: 1.0
                ),
            ])
        ])
        let sut = HomeViewModelImpl(
            router: HomeRouter(navigationController: UINavigationController()),
            weatherRepository: weatherRepositoryMock
        )

        let expectation = expectation(description: "Should send initial state")

        sut.refreshWeatherForecast()

        sut.state.asObservable().subscribe(
            onNext: { response in
                XCTAssertNotNil(response)
                XCTAssertTrue(response.midDayWeatherForecasts.count == 1)
                expectation.fulfill()
            }
        )
        .disposed(by: disposeBag)

        waitForExpectations(timeout: 0.5) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
    }
}
