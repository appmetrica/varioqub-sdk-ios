
import Foundation

extension Bool {

    static let trueValues = ["true", "yes"]
    static let falseValues = ["false", "no"]
    static let posixLocale = Locale(identifier: "en_US_POSIX")

    init?(string: String) {
        if let i = Int(string) {
            self = i != 0 ? true : false
        } else if Self.trueValues.contains(string.lowercased(with: Self.posixLocale)) {
            self = true
        } else if Self.falseValues.contains(string.lowercased(with: Self.posixLocale)) {
            self = false
        } else {
            return nil
        }
    }

}
