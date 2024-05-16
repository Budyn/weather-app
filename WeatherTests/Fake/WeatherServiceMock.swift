import RxSwift
@testable import Weather

final class WeatherServiceMock: WeatherService {

    var didCall = false

    func getWeatherForecast(in city: String, numberOfDays: Int) -> Single<[WeatherForecast]> {
        didCall = true
        return Observable.just([]).asSingle()
    }
}
