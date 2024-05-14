import Foundation
import RxSwift

struct HomeState {
    let title: String
}

final class HomeViewModel {

    let state = HomeState(title: "Home")

    private let weatherService: WeatherService
    private let disposeBag = DisposeBag()

    init(weatherService: WeatherService) {
        self.weatherService = weatherService
    }

    func requestWeatherForecast() {
        weatherService.getWeatherForecast(for: "Paris").subscribe(onSuccess: {
            print($0)
        }).disposed(by: disposeBag)
    }
}
