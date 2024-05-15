import Foundation
import RxSwift

protocol WeatherService {
    func getWeatherForecast(in city: String, numberOfDays: Int) -> Single<[WeatherForecast]>
}

enum WeatherServiceError: Error {
    case deallocated
    case statusCode(Int)
    case missingData
    case decoding
}

final class WeatherServiceImpl: WeatherService {

    private let apiKey = "4983eab2521f985c5ec7f3c38e4808ea"

    func getWeatherForecast(in city: String, numberOfDays: Int) -> Single<[WeatherForecast]> {
        getCooridinates(for: city).flatMap { [weak self] coordinates in
            guard let self = self else { throw WeatherServiceError.deallocated }
            guard let coordinates = coordinates.first else { throw WeatherServiceError.missingData }

            return self.getForecast(for: coordinates)
        }.map { [weak self] response in
            guard let self = self else { throw WeatherServiceError.deallocated }
            return self.extractWeatherForecasts(from: response, numberOfDays: numberOfDays)
        }
    }

    private func extractWeatherForecasts(
        from response: WeatherForecastResponse,
        numberOfDays: Int
    ) -> [WeatherForecast] {
        let futureForecasts = response.forecasts
            .filter { !Calendar.current.isDateInToday($0.timestamp) }

        return (1 ... numberOfDays).compactMap { interval in
            let intervalDate = Calendar.current.date(byAdding: .day, value: interval, to: Date())!

            let forecastsInIntervalDate = futureForecasts.filter {
                Calendar.current.isDate($0.timestamp, equalTo: intervalDate, toGranularity: .day)
            }

            let dayMaxTemperature = forecastsInIntervalDate
                .max { $0.weather.maxTemperature < $1.weather.maxTemperature }
                .map { $0.weather.maxTemperature } ?? 0
            let dayMinTemperature = forecastsInIntervalDate
                .min { $0.weather.minTemperature < $1.weather.minTemperature }
                .map { $0.weather.minTemperature } ?? 0

            return forecastsInIntervalDate.isEmpty
                ? nil
                : WeatherForecast(
                    date: intervalDate,
                    forecasts: forecastsInIntervalDate.map {
                        WeatherForecast.Forecast(
                            timestamp: $0.timestamp,
                            temperature: $0.weather.temperature,
                            minTemperature: $0.weather.minTemperature,
                            maxTemperature: $0.weather.maxTemperature,
                            pressure: $0.weather.pressure,
                            humidity: $0.weather.humidity,
                            conditionsDescription: $0.weatherConditions.description,
                            dayMinTemperature: dayMinTemperature, 
                            dayMaxTemperature: dayMaxTemperature
                        )
                    }
                )
        }
    }

    private func getForecast(
        for coordinates: CoordinatesResponse
    ) -> Single<WeatherForecastResponse> {
        let url = buildWeatherForecastURL(for: coordinates)
        return get(url: url)
    }

    private func getCooridinates(for city: String) -> Single<[CoordinatesResponse]> {
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

    private func buildWeatherForecastURL(for coordinates: CoordinatesResponse) -> URL {
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
