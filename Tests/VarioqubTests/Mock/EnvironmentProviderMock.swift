import Foundation
@testable import Varioqub

final class EnvironmentProviderMock: EnvironmentProvider {
    
    
    init(currentDate: Date) {
        self.currentDate = currentDate
    }
    
    var currentDate: Date
    
    var version: String = "1.2.3"
    
    var versionCode: String = "3.2.1"
    
    var platform: String = "test-ios"
    
    var language: String = "es_ES"

    var osVersion: String = "16.4.1"
    
}
