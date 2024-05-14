import Foundation

struct WeatherForecast {

    struct Forecast {

        struct Weather {
            let temperature: Double
            let minTemperature: Double
            let maxTemperature: Double
            let pressure: Double
            let humidity: Double
        }

        let timestamp: Date
        let weather: Weather
    }

    let forecasts: [Forecast]
}

extension WeatherForecast: Decodable {

    enum CodingKeys: String, CodingKey {
        case forecasts = "list"
    }
}

extension WeatherForecast.Forecast: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        timestamp = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: "dt"))
        weather = try container.decode(Weather.self, forKey: "main")
    }
}

extension WeatherForecast.Forecast.Weather: Decodable {

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
}
