import Foundation
import RxSwift
import RxCocoa

struct HomeState {
    let city: String
    let midDayWeatherForecasts: [WeatherForecast.Forecast]
}

final class HomeViewModel {

    let state: Driver<HomeState>

    private let _state: BehaviorRelay<HomeState>

    private let weatherRepository: WeatherRepository
    private let disposeBag = DisposeBag()
    private let city = "Paris"

    init(weatherRepository: WeatherRepository) {
        self._state = BehaviorRelay(value: HomeState(city: city, midDayWeatherForecasts: []))
        self.state = _state.asDriver(
            onErrorJustReturn: HomeState(city: city, midDayWeatherForecasts: [])
        )
        self.weatherRepository = weatherRepository
    }

    func requestWeatherForecast() {
        weatherRepository
            .getWeatherForecasts(in: "Paris", numberOfDays: 5)
            .compactMap { [weak self] in
                self?.findMidDayForecasts(from: $0)
            }
            .subscribe(onSuccess: { [weak self, city] in
                self?._state.accept(HomeState(city: city, midDayWeatherForecasts: $0))
            })
            .disposed(by: disposeBag)
    }

    private func findMidDayForecasts(
        from weatherForecasts: [WeatherForecast]
    ) -> [WeatherForecast.Forecast] {
        weatherForecasts.compactMap {
            $0.forecasts.first {
                if let hour = Calendar.current.dateComponents([.hour], from: $0.timestamp).hour {
                    return (12 ..< 17).contains(hour)
                } else {
                    return false
                }
            } ?? $0.forecasts.first
        }
    }
}
