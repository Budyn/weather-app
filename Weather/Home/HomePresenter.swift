import Foundation

struct WeatherRowViewState {
    let day: String
    let fullDate: String
    let temperature: String
    let maxTemperature: String
    let minTemperature: String
    let pressure: String
    let humidity: String
    let conditionsDescription: String
}

struct HomePresenter {
    
    private var dayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = .current
        return formatter
    }

    private var fullDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = .current
        return formatter
    }

    func makeViewState(from state: HomeState) -> [WeatherRowViewState] {
        state.weatherForecasts.map {
            WeatherRowViewState(
                day: dayDateFormatter.string(from: $0.date),
                fullDate: fullDateFormatter.string(from: $0.date),
                temperature: formatTemperature(from: $0.forecasts.first!),
                maxTemperature: formatMaxTemperature(from: $0.forecasts.first!),
                minTemperature: formatMinTemperature(from: $0.forecasts.first!),
                pressure: formatPressure(from: $0.forecasts.first!),
                humidity: formatHumidity(from: $0.forecasts.first!),
                conditionsDescription: formatConditionsDescription(from: $0.forecasts.first!)
            )
        }
    }

    func formatTemperature(from forecast: WeatherForecast.Forecast) -> String {
        "\(Int(forecast.maxTemperature))℃,"
    }

    func formatMaxTemperature(from forecast: WeatherForecast.Forecast) -> String {
        String(localized: "High temp: \(Int(forecast.maxTemperature))℃")
    }

    func formatMinTemperature(from forecast: WeatherForecast.Forecast) -> String {
        String(localized: "Low temp: \(Int(forecast.maxTemperature))℃")
    }

    func formatPressure(from forecast: WeatherForecast.Forecast) -> String {
        String(localized: "Pressure \(Int(forecast.pressure))hPa")
    }

    func formatHumidity(from forecast: WeatherForecast.Forecast) -> String {
        String(localized: "Humidity: \(Int(forecast.humidity))%")
    }

    func formatConditionsDescription(from forecast: WeatherForecast.Forecast) -> String {
        forecast.conditionsDescription.capitalized
    }
}
