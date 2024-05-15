import Foundation
import RxCocoa
import RxSwift
import UIKit

struct HomeState {
    let city: String
    let weatherForecasts: [WeatherForecast]
    let midDayWeatherForecasts: [WeatherForecast.Forecast]
}

protocol HomeViewModel {
    func openWeatherDetails(for indexPath: IndexPath)
    func refreshWeatherForecast()
}

final class HomeViewModelImpl: HomeViewModel {

    let state: Driver<HomeState>

    private let _state: BehaviorRelay<HomeState>

    private let router: HomeRouter
    private let weatherRepository: WeatherRepository
    private let disposeBag = DisposeBag()
    private let city = String(localized: "Paris")

    init(
        router: HomeRouter,
        weatherRepository: WeatherRepository
    ) {
        self._state = BehaviorRelay(
            value: HomeState(
                city: city,
                weatherForecasts: [],
                midDayWeatherForecasts: []
            )
        )
        self.state = _state.asDriver(
            onErrorJustReturn: HomeState(
                city: city,
                weatherForecasts: [],
                midDayWeatherForecasts: []
            )
        )
        self.router = router
        self.weatherRepository = weatherRepository
    }

    func openWeatherDetails(for indexPath: IndexPath) {
        let viewModel = DetailViewModel(
            weatherForecast: _state.value.weatherForecasts[indexPath.row]
        )
        let view = DetailViewController(
            state: viewModel.state.map(DetailPresenter().makeViewState(from:))
        )
        router.present(view)
    }

    func refreshWeatherForecast() {
        weatherRepository
            .getWeatherForecasts(in: city, numberOfDays: 5)
            .subscribe(onSuccess: { [weak self, city] in
                self?._state.accept(
                    HomeState(
                        city: city,
                        weatherForecasts: $0,
                        midDayWeatherForecasts: self?.findMidDayForecasts(from: $0) ?? []
                    )
                )
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
