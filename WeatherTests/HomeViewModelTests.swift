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

    func testRefreshWeatherForecastRequestsData() {
        let weatherServiceMock = WeatherServiceMock()
        let sut = HomeViewModelImpl(
            router: HomeRouter(navigationController: UINavigationController()),
            weatherRepository: WeatherRepositoryImpl(
                weatherService: weatherServiceMock
            )
        )

        sut.refreshWeatherForecast()
    }
}
