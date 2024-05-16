import Foundation

struct WeatherForecastResponse {

    struct Forecast {

        struct Weather {
            let temperature: Double
            let minTemperature: Double
            let maxTemperature: Double
            let pressure: Double
            let humidity: Double
        }

        struct WeatherConditions {
            let description: String
            let icon: String
        }

        let timestamp: Date
        let weather: Weather
        let weatherConditions: WeatherConditions
    }

    let forecasts: [Forecast]
}

extension WeatherForecastResponse: Decodable {

    enum CodingKeys: String, CodingKey {
        case forecasts = "list"
    }
}

extension WeatherForecastResponse.Forecast: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: String.self)

        timestamp = Date(timeIntervalSince1970: try container.decode(Double.self, forKey: "dt"))
        weather = try container.decode(Weather.self, forKey: "main")
        
        let conditions = try container.decode([WeatherConditions].self, forKey: "weather")
        
        if let condition = conditions.first {
            weatherConditions = condition
        } else {
            throw DataFetchingError.decoding
        }
    }
}

extension WeatherForecastResponse.Forecast.Weather: Decodable {

    enum CodingKeys: String, CodingKey {
        case temperature = "temp"
        case minTemperature = "temp_min"
        case maxTemperature = "temp_max"
        case pressure = "pressure"
        case humidity = "humidity"
    }
}

extension WeatherForecastResponse.Forecast.WeatherConditions: Decodable {

    enum CodingKeys: String, CodingKey {
        case description = "description"
        case icon = "icon"
    }
}
