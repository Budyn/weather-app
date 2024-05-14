import Foundation
import RxSwift

protocol WeatherService {
    func getWeatherForecast(for city: String) -> Single<WeatherForecast>
}

enum WeatherServiceError: Error {
    case deallocated
    case statusCode(Int)
    case missingData
    case decoding
}

final class WeatherServiceImpl: WeatherService {

    private let apiKey = "4983eab2521f985c5ec7f3c38e4808ea"

    func getWeatherForecast(for city: String) -> Single<WeatherForecast> {
        getCooridinates(for: city).flatMap { [weak self] coordinates in
            guard let self = self else { throw WeatherServiceError.deallocated }
            guard let coordinates = coordinates.first else { throw WeatherServiceError.missingData }

            return self.getForecast(for: coordinates)
        }
    }

    private func getForecast(for coordinates: Coordinates) -> Single<WeatherForecast> {
        let url = buildWeatherForecastURL(for: coordinates)
        return get(url: url)
    }

    private func getCooridinates(for city: String) -> Single<[Coordinates]> {
        let url = buildGeocodingURL(for: city)
        return get(url: url)
    }

    private func get<T: Decodable>(url: URL) -> Single<T> {
        Single.create { single in
            let request = URLRequest(url: url)
            let task = URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    single(.failure(error))
                    return
                }

                if let statusCode = (response as? HTTPURLResponse)?.statusCode, statusCode != 200 {
                    single(.failure(WeatherServiceError.statusCode(statusCode)))
                    return
                }

                guard let data = data else {
                    single(.failure(WeatherServiceError.missingData))
                    return
                }

                do {
                    let response = try JSONDecoder().decode(T.self, from: data)

                    single(.success(response))
                } catch {
                    single(.failure(WeatherServiceError.decoding))
                    return
                }

            }

            task.resume()

            return Disposables.create { task.cancel() }
        }
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

    private func buildWeatherForecastURL(for coordinates: Coordinates) -> URL {
        var urlComponents = URLComponents()

        urlComponents.scheme = "https"
        urlComponents.host = "api.openweathermap.org"
        urlComponents.path = "/data/2.5/forecast"
        urlComponents.queryItems = [
            URLQueryItem(name: "lat", value: "\(coordinates.latitude)"),
            URLQueryItem(name: "lon", value: "\(coordinates.longitude)"),
            URLQueryItem(name: "units", value: "metric"),
            URLQueryItem(name: "appid", value: apiKey)
        ]

        return urlComponents.url!
    }
}

private struct Coordinates {
    let latitude: Double
    let longitude: Double
}

extension Coordinates: Decodable {
    enum CodingKeys: String, CodingKey {
        case latitude = "lat"
        case longitude = "lon"
    }
}
