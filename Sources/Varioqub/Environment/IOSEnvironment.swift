import Foundation
import UIKit

final class IOSEnvironment: EnvironmentProvider {

    init() { }

    var version: String {
        Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }

    var versionCode: String {
        Bundle.main.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }

    var platform: String { "ios" }

    var language: String { Locale.current.languageCode ?? "" }

    var osVersion: String { UIDevice.current.systemVersion }
    
    var currentDate: Date { Date() }

}
