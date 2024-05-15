import Foundation
import RxCocoa
import RxSwift
import UIKit

struct DetailState {
    let weatherForecast: WeatherForecast
}

final class DetailViewModel {
    
    let state: Driver<DetailState>
    private let _state: BehaviorRelay<DetailState>

    init(weatherForecast: WeatherForecast) {
        self._state = BehaviorRelay(value: DetailState(weatherForecast: weatherForecast))
        self.state = _state.asDriver(
            onErrorJustReturn: DetailState(
                weatherForecast: WeatherForecast(date: Date(), forecasts: [])
            )
        )
    }
}
