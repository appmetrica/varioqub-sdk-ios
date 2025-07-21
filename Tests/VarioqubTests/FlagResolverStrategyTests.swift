
import XCTest
@testable import Varioqub

final class FlagResolverStrategyTests: XCTestCase {

    let configValue = VarioqubValue(string: "123")
    let defaultIntValue: Int = 234
    let defaultStringValue: String = "234"

    func testIntValues() {
        let result1 = FlagResolverStrategy.selectValue(
                configValue: configValue,
                userProviderDefaultValue: defaultIntValue,
                type: Int.self
        )
        XCTAssertEqual(result1, configValue.intValue)

        let result2 = FlagResolverStrategy.selectValue(
                configValue: nil,
                userProviderDefaultValue: defaultIntValue,
                type: Int.self
        )

        XCTAssertEqual(result2, defaultIntValue)

        let result3 = FlagResolverStrategy.selectValue(
                configValue: nil,
                userProviderDefaultValue: nil,
                type: Int.self
        )

        XCTAssertEqual(result3, Int.defaultValue)
    }

    func testStringValues() {
        let result1 = FlagResolverStrategy.selectValue(
                configValue: configValue,
                userProviderDefaultValue: defaultStringValue,
                type: String.self
        )
        XCTAssertEqual(result1, configValue.stringValue)

        let result2 = FlagResolverStrategy.selectValue(
                configValue: nil,
                userProviderDefaultValue: defaultStringValue,
                type: String.self
        )

        XCTAssertEqual(result2, defaultStringValue)

        let result3 = FlagResolverStrategy.selectValue(
                configValue: nil,
                userProviderDefaultValue: nil,
                type: String.self
        )

        XCTAssertEqual(result3, String.defaultValue)
    }

}
