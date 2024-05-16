import RxSwift
@testable import Weather

final class GeocodingServiceStub: GeocodingService {

    private let response: CoordinatesResponse?

    init(response: CoordinatesResponse?) {
        self.response = response
    }

    func getCoordinates(for city: String) -> Single<CoordinatesResponse?> {
        Observable.just(response).asSingle()
    }
}
