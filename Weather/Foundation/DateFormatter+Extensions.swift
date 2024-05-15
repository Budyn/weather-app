import Foundation

extension DateFormatter {
    
    static var dayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "EEEE"
        formatter.locale = .current
        formatter.calendar = .autoupdatingCurrent
        return formatter
    }

    static var fullDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "dd/MM/yyyy"
        formatter.locale = .current
        formatter.calendar = .autoupdatingCurrent
        return formatter
    }

    static var hourWithMinutesDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        formatter.locale = .current
        formatter.calendar = .autoupdatingCurrent
        return formatter
    }
}
