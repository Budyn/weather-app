import Foundation
import RxSwift

struct Weather {
    let date: Date
    let temperature: Double
    let minTemperature: Double
    let maxTemperature: Double
    let pressure: Double
    let humidity: Double
}

protocol WeatherRepository {
    func getWeatherForecast(in city: String) -> Single<[Weather]>
}

final class WeatherRepositoryImpl: WeatherRepository {

    private let weatherService: WeatherService

    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }

    func getWeatherForecast(in city: String) -> Single<[Weather]> {
        fatalError()
    }
}
