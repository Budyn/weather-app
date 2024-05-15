import Foundation

struct WeatherForecast {

    struct Forecast {
        let timestamp: Date
        let temperature: Double
        let minTemperature: Double
        let maxTemperature: Double
        let pressure: Double
        let humidity: Double
        let conditionsDescription: String
        let dayMinTemperature: Double
        let dayMaxTemperature: Double
    }

    let date: Date
    let forecasts: [Forecast]
}
