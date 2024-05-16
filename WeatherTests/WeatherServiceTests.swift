import RxBlocking
import RxSwift
import RxTest
@testable import Weather
import XCTest

final class WeatherServiceTests: XCTestCase {

    private var disposeBag: DisposeBag!

    override func setUp() {
        super.setUp()
        disposeBag = DisposeBag()
    }

    override func tearDown() {
        disposeBag = nil
        super.tearDown()
    }

    func testGetWeatherForecastReturnsWeatherForecast() {
        let dataFetcher = DataFetcherStub(response: fakeWeatherForecast)
        let geocodingStub = GeocodingServiceStub(
            response: CoordinatesResponse(latitude: 40, longitude: 40)
        )
        let sut = WeatherServiceImpl(
            dataFetcher: dataFetcher,
            geocodingService: geocodingStub
        )

        let expectation = expectation(description: "Should send data")

        sut.getWeatherForecast(in: "Paris", numberOfDays: 5).asObservable()
            .subscribe(
                onNext: { response in
                    XCTAssertEqual(response.count, 5)
                    XCTAssertEqual(response.first!.forecasts.first!.pressure, 1008)
                    XCTAssertEqual(response.first!.forecasts.first!.conditionsDescription, "clear sky")
                    expectation.fulfill()
                },
                onError: { _ in
                    XCTFail("Should not happen")
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

    func testGetWeatherForecastWithCorruptedResponseReturnsError() {
        let dataFetcher = DataFetcherStub(errorToSend: DataFetchingError.decoding)
        let geocodingStub = GeocodingServiceStub(
            response: CoordinatesResponse(latitude: 40, longitude: 40)
        )
        let sut = WeatherServiceImpl(
            dataFetcher: dataFetcher,
            geocodingService: geocodingStub
        )

        let expectation = expectation(description: "Should send error")

        sut.getWeatherForecast(in: "Paris", numberOfDays: 5).asObservable()
            .subscribe(
                onNext: { _ in
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

        waitForExpectations(timeout: 0.5) { error in
            guard error == nil else {
                XCTFail(error!.localizedDescription)
                return
            }
        }
    }
}

