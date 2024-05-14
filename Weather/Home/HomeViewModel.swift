import Foundation
import RxSwift
import RxCocoa

struct HomeState {
    let weatherForecasts: [WeatherForecast]
}

final class HomeViewModel {

    let state: Driver<HomeState>

    private let _state: BehaviorRelay<HomeState>

    private let weatherRepository: WeatherRepository
    private let disposeBag = DisposeBag()

    init(weatherRepository: WeatherRepository) {
        self._state = BehaviorRelay(value: HomeState(weatherForecasts: []))
        self.state = _state.asDriver(onErrorJustReturn: HomeState(weatherForecasts: []))
        self.weatherRepository = weatherRepository
    }

    func requestWeatherForecast() {
        weatherRepository.getWeatherForecasts(in: "Paris", numberOfDays: 5)
            .subscribe(onSuccess: { [weak self] in
                self?._state.accept(HomeState(weatherForecasts: $0))
            })
            .disposed(by: disposeBag)
    }
}
