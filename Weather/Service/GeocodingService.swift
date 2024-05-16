import Foundation
import RxSwift

protocol GeocodingService {
    func getCoordinates(for city: String) -> Single<CoordinatesResponse?>
}

enum GeocodingServiceError: Error {
    case deallocated
    case missingData
}

final class GeocodingServiceImpl: GeocodingService {

    private let dataFetcher: DataFetching

    init(dataFetcher: DataFetching) {
        self.dataFetcher = dataFetcher
    }

    private let apiKey = "4983eab2521f985c5ec7f3c38e4808ea"

    func getCoordinates(for city: String) -> Single<CoordinatesResponse?> {
        dataFetcher.data(for: URLRequest(url: buildGeocodingURL(for: city)))
            .map { (response: [CoordinatesResponse]) in response.first }
    }

    private func buildGeocodingURL(for city: String) -> URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = "http"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/geo/1.0/direct"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city.lowercased()),
            URLQueryItem(name: "limit", value: "10"),
            URLQueryItem(name: "appid", value: apiKey)
        ]

        return urlComponents.url!
    }
}
