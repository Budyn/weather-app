import Foundation
import RxSwift

protocol WeatherService {
    func getWeatherForecast(in city: String, numberOfDays: Int) -> Single<[WeatherForecast]>
}

enum WeatherServiceError: Error {
    case deallocated
    case missingData
}

final class WeatherServiceImpl: WeatherService {

    private let dataFetcher: DataFetching
    private let geocodingService: GeocodingService

    init(dataFetcher: DataFetching, geocodingService: GeocodingService) {
        self.dataFetcher = dataFetcher
        self.geocodingService = geocodingService
    }

    private let apiKey = "4983eab2521f985c5ec7f3c38e4808ea"

    func getWeatherForecast(in city: String, numberOfDays: Int) -> Single<[WeatherForecast]> {
        geocodingService.getCoordinates(for: city)
            .flatMap { [weak self] in
                guard let self = self else { throw WeatherServiceError.deallocated }
                guard let coordinates = $0 else { throw WeatherServiceError.missingData }

                return self.getForecast(for: coordinates)
            }
            .map { [weak self] response in
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
        let request = URLRequest(url: buildWeatherForecastURL(for: coordinates))
        return dataFetcher.data(for: request)
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
