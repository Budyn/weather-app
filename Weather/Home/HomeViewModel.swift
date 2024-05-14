import Foundation

struct HomeState {
    let title: String
}

final class HomeViewModel {

    let state = HomeState(title: "Home")

    private let weatherService: WeatherService

    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }

    func requestWeatherForecast() {
        _ = weatherService.getForecast(for: "Paris")
    }
}
