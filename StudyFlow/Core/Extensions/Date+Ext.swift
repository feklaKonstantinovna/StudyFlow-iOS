import Foundation

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }

    var dateKey: String {
        let f = DateFormatter()
        f.dateFormat = "yyyy-MM-dd"
        f.locale = Locale(identifier: "en_US_POSIX")
        return f.string(from: self)
    }

    func minutesFromStartOfDay() -> Int {
        let cal = Calendar.current
        let h = cal.component(.hour, from: self)
        let m = cal.component(.minute, from: self)
        return h * 60 + m
    }

    static func from(date: Date, minutes: Int) -> Date {
        let start = date.startOfDay
        return Calendar.current.date(byAdding: .minute, value: minutes, to: start) ?? start
    }
}
