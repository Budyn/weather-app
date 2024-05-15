import Foundation

struct DetailViewState {
    let title: String
    let rows: [WeatherRowViewState]
}

struct DetailPresenter {
    func makeViewState(from state: DetailState) -> DetailViewState {
        DetailViewState(
            title: formatTitle(for: state.weatherForecast.date),
            rows: state.weatherForecast.forecasts.map {
                WeatherRowViewState(
                    headline: DateFormatter.hourWithMinutesDateFormatter.string(from: $0.timestamp),
                    fullDate: "",
                    temperature: format(temperature: $0.temperature),
                    maxTemperature: format(maxTemperature: $0.maxTemperature),
                    minTemperature: format(minTemperature: $0.minTemperature),
                    pressure: format(pressure: $0.pressure),
                    humidity: format(humidity: $0.humidity),
                    conditionsDescription: $0.conditionsDescription.capitalized, 
                    isChevronPresented: false
                )
            }
        )
    }

    private func formatTitle(for date: Date) -> String {
        "Weather for \(DateFormatter.fullDateFormatter.string(from: date))"
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
