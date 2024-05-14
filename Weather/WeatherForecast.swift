import Foundation

struct WeatherForecast {
    let forecasts: [Forecast]
}

extension WeatherForecast {
    struct Forecast {
        let timestamp: Date
    }
}

extension WeatherForecast: Decodable {}

extension WeatherForecast.Forecast: Decodable {
    enum CodingKeys: String, CodingKey {
        case timestamp = "dt"
    }
}
