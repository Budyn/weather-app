import Foundation
import RxSwift

protocol WeatherRepository {
    func getWeatherForecasts(in city: String, numberOfDays: Int) -> Single<[WeatherForecast]>
}

final class WeatherRepositoryImpl: WeatherRepository {

    private let weatherService: WeatherService

    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }

    func getWeatherForecasts(in city: String, numberOfDays: Int) -> Single<[WeatherForecast]> {
        weatherService.getWeatherForecast(in: city, numberOfDays: numberOfDays)
    }
}
