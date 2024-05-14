import UIKit

final class WeatherRowView: UITableViewCell {

    private let dayLabel = UILabel()
    private let dateLabel = UILabel()
    private let conditionsDescription = UILabel()
    private let temperature = UILabel()
    private let maxTemperature = UILabel()
    private let minTemperature = UILabel()
    private let humidity = UILabel()
    private let pressure = UILabel()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        layout()
        setup()
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func layout() {
        let dateStackView = UIStackView(
            arrangedSubviews: [dayLabel, dateLabel]
        )

        dateStackView.axis = .vertical
        dateStackView.spacing = 4
        dateStackView.alignment = .leading

        let conditionsStackView = UIStackView(
            arrangedSubviews: [temperature, conditionsDescription]
        )

        conditionsStackView.spacing = 16

        let temperatureRangeStackView = UIStackView(
            arrangedSubviews: [maxTemperature, minTemperature]
        )

        temperatureRangeStackView.spacing = 16

        let detailsStackView = UIStackView(
            arrangedSubviews: [humidity, pressure]
        )

        detailsStackView.spacing = 16

        let weatherStackView = UIStackView(arrangedSubviews: [
            dateStackView,
            .spacer(height: 16),
            conditionsStackView,
            .spacer(height: 16),
            temperatureRangeStackView,
            .spacer(height: 8),
            detailsStackView
        ])

        weatherStackView.axis = .vertical
        weatherStackView.alignment = .leading

        let chevron = UIImageView(image: UIImage(systemName: "chevron.right"))

        chevron.contentMode = .scaleAspectFit

        let contentStackView = UIStackView(arrangedSubviews: [weatherStackView, chevron])

        contentStackView.translatesAutoresizingMaskIntoConstraints = false
        contentStackView.isLayoutMarginsRelativeArrangement = true
        contentStackView.layoutMargins = UIEdgeInsets(top: 16, left: 16, bottom: 16, right: 16)

        contentView.addSubview(contentStackView)

        contentStackView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        contentStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        contentStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        contentStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor).isActive = true
    }

    private func setup() {
        dayLabel.font = .preferredFont(forTextStyle: .largeTitle)
        dayLabel.textColor = .accent
        dateLabel.font = .preferredFont(forTextStyle: .footnote)
        temperature.font = .preferredFont(forTextStyle: .title2)
        conditionsDescription.font = .preferredFont(forTextStyle: .title2)
        maxTemperature.font = .preferredFont(forTextStyle: .footnote)
        minTemperature.font = .preferredFont(forTextStyle: .footnote)
        humidity.font = .preferredFont(forTextStyle: .footnote)
        pressure.font = .preferredFont(forTextStyle: .footnote)
    }

    func update(state: WeatherRowViewState) {
        dayLabel.text = state.day
        dateLabel.text = state.fullDate
        temperature.text = state.temperature
        conditionsDescription.text = state.conditionsDescription
        maxTemperature.text = state.maxTemperature
        minTemperature.text = state.minTemperature
        humidity.text = state.humidity
        pressure.text = state.pressure
    }
}
