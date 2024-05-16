import RxSwift
@testable import Weather

final class WeatherRepositoryMock: WeatherRepository {

    var didCall = false

    private let forecasts: [WeatherForecast]

    init(forecasts: [WeatherForecast]) {
        self.forecasts = forecasts
    }

    func getWeatherForecasts(in city: String, numberOfDays: Int) -> Single<[WeatherForecast]> {
        didCall = true
        return Observable.just(forecasts).asSingle()
    }
}
