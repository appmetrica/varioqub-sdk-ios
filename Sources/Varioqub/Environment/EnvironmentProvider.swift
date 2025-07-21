
import Foundation

protocol EnvironmentProvider {
    var version: String { get }
    var versionCode: String { get }
    var platform: String { get }
    var language: String { get }
    var osVersion: String { get }
    var currentDate: Date { get }
}
