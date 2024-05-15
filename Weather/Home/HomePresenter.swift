import Foundation

struct HomeViewState {
    let title: String
    let rows: [WeatherRowViewState]
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

    func makeViewState(from state: HomeState) -> HomeViewState {
        HomeViewState(
            title: "Weather Forecast for \(state.city.capitalized)",
            rows: state.midDayWeatherForecasts.map {
                WeatherRowViewState(
                    day: dayDateFormatter.string(from: $0.timestamp),
                    fullDate: fullDateFormatter.string(from: $0.timestamp),
                    temperature: format(temperature: $0.temperature),
                    maxTemperature: format(maxTemperature: $0.dayMaxTemperature),
                    minTemperature: format(minTemperature: $0.dayMinTemperature),
                    pressure: format(pressure: $0.pressure),
                    humidity: format(humidity: $0.humidity),
                    conditionsDescription: $0.conditionsDescription.capitalized
                )
            }
        )
    }

    func format(temperature: Double) -> String {
        "\(Int(temperature))℃,"
    }

    func format(maxTemperature: Double) -> String {
        String(localized: "High temp: \(Int(maxTemperature))℃")
    }

    func format(minTemperature: Double) -> String {
        String(localized: "Low temp: \(Int(minTemperature))℃")
    }

    func format(pressure: Double) -> String {
        String(localized: "Pressure: \(Int(pressure))hPa")
    }

    func format(humidity: Double) -> String {
        String(localized: "Humidity: \(Int(humidity))%")
    }
}
