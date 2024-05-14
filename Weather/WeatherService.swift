import Foundation
import RxSwift

protocol WeatherService {
    func getForecast(for city: String) -> WeatherForecast
}

final class WeatherServiceImpl: WeatherService {

    private let apiKey = "4983eab2521f985c5ec7f3c38e4808ea"

    func getForecast(for city: String) -> WeatherForecast {
        let url = buildGeocodingURL(for: city)
        print(url)
        return WeatherForecast(forecasts: [])
    }

    func buildGeocodingURL(for city: String) -> URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = "http"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/geo/1.0/direct"
        urlComponents.queryItems = [
            URLQueryItem(name: "q", value: city.lowercased()),
            URLQueryItem(name: "limit", value: "1"),
            URLQueryItem(name: "appid", value: apiKey)
        ]

        return urlComponents.url!
    }
}

private struct Coordinates: Decodable {
    let latitude: Double
    let longitude: Double
}
