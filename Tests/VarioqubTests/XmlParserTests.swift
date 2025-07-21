import XCTest
@testable import Varioqub

final class XmlParserTests: XCTestCase {

    let goodXmlString = """
                        <defaults>
                            <entry>
                                <key>first_button_color</key>
                                <value>green</value>
                            </entry>
                            <entry>
                                <key>second_button_color</key>
                                <value>red</value>
                            </entry>
                            <entry>
                                <key>is_third_button_visible</key>
                                <value>false</value>
                            </entry>
                            <entry>
                                <key>third_button_padding_top</key>
                                <value>10</value>
                            </entry>
                        </defaults>
                        """
    let goodResult: [VarioqubFlag: VarioqubValue] = [
        .init(rawValue: "first_button_color"): .init(string: "green"),
        .init(rawValue: "second_button_color"): .init(string: "red"),
        .init(rawValue: "is_third_button_visible"): .init(string: "false"),
        .init(rawValue: "third_button_padding_top"): .init(string: "10"),
    ]


    let partialBad = """
                     <defaults>
                         <entry>
                             <key>first_button_color</key>
                             <values>green</values>
                         </entry>
                         <entry>
                             <key>second_button_color</key>
                             <value>red</value>
                         </entry>
                         <entry>
                             <keys>is_third_button_visible</keys>
                             <val>false</val>
                         </entry>
                         <entry>
                             <key>third_button_padding_top</key>
                             <value>10</value>
                         </entry>
                     </defaults>
                     """

    let invalidTags = """
                      <defaults>
                              <metrica_entry>
                                  <abc>first_button_color</abc>
                                  <value>green</value>
                              </metrica_entry>
                              <entry>
                                  <metrica_key>second_button_color</metrica_key>
                                  <value>red</value>
                              </entry>
                              <entry>
                                  <keys>is_third_button_visible</keys>
                                  <metrica_value>false</metrica_value>
                              </entry>
                              <abc>
                                  <key>third_button_padding_top</key>
                                  <cba>10</cba>
                              </abc>
                          </defaults>
                      """

    override func setUp() {
        super.setUp()
    }

    func testGoodParsing() throws {
        let parser = XmlParser(data: goodXmlString.data(using: .utf8)!)
        let result = try parser.parse()

        XCTAssertEqual(result, goodResult)
    }

    func testPartialParsing() throws {
        let parser = XmlParser(data: partialBad.data(using: .utf8)!)

        XCTAssertThrowsError(try parser.parse())
    }

    func testPartialInvalidTags() throws {
        let parser = XmlParser(data: invalidTags.data(using: .utf8)!)

        XCTAssertThrowsError(try parser.parse())
    }
}
