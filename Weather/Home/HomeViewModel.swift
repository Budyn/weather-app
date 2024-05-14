import Foundation
import RxSwift

struct HomeState {
    let title: String
}

final class HomeViewModel {

    let state = HomeState(title: "Home")

    private let weatherRepository: WeatherRepository
    private let disposeBag = DisposeBag()

    init(weatherRepository: WeatherRepository) {
        self.weatherRepository = weatherRepository
    }

    func requestWeatherForecast() {
        weatherRepository.getWeatherForecast(in: "Paris").subscribe(onSuccess: {
            print($0)
        }).disposed(by: disposeBag)
    }
}
