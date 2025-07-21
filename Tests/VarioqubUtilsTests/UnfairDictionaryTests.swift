
import Foundation
import XCTest
@testable import VarioqubUtils


final class UnfairDictionaryTests: XCTestCase {
    
    var dictionary: UnfairDictionary<String, String>!
    
    
    override func setUp() {
        super.setUp()

        dictionary = UnfairDictionary<String, String>()
    }
    
    func testGet() {
        let initDict = [
            "q": "w",
            "a": "s",
            "z": "x",
        ]
        
        dictionary = .init(initDict)
        
        XCTAssertEqual(dictionary.count, 3)
        XCTAssertEqual(dictionary["q"], "w")
        XCTAssertEqual(dictionary["a"], "s")
        XCTAssertEqual(dictionary["z"], "x")
    }
    
    func testSet() {
        dictionary["q"] = "w"
        dictionary["a"] = "s"
        dictionary["z"] = "x"
        dictionary["a"] = "d"
        
        XCTAssertEqual(dictionary.count, 3)
        XCTAssertEqual(dictionary["q"], "w")
        XCTAssertEqual(dictionary["a"], "d")
        XCTAssertEqual(dictionary["z"], "x")
    }
    
    func testPut() {
        let initDict = [
            "q": "w",
        ]
        
        dictionary = .init(initDict)
        dictionary.replace(by: ["a": "s", "z": "x"])
        XCTAssertEqual(dictionary.count, 2)
        XCTAssertEqual(dictionary["a"], "s")
        XCTAssertEqual(dictionary["z"], "x")
        XCTAssertNil(dictionary["q"])
    }
    
    func testClear() {
        let initDict = [
            "q": "w",
            "a": "s",
            "z": "x",
        ]
        
        dictionary = .init(initDict)
        
        dictionary.removeAll()
        XCTAssertEqual(dictionary.count, 0)
        XCTAssertNil(dictionary["q"])
        XCTAssertNil(dictionary["a"])
        XCTAssertNil(dictionary["z"])
    }
    
    func testGetOrPut() {
        let r1 = dictionary.getOrPut(key: "q", putClosure: { "w" })
        let r2 = dictionary.getOrPut(key: "a", putClosure: { "s" })
        let r3 = dictionary.getOrPut(key: "z", putClosure: { "x" })
        let r4 = dictionary.getOrPut(key: "a", putClosure: { "d" })
        
        XCTAssertEqual(dictionary.count, 3)
        XCTAssertEqual(r1, "w")
        XCTAssertEqual(r2, "s")
        XCTAssertEqual(r3, "x")
        XCTAssertEqual(r4, "s")
        XCTAssertEqual(dictionary["q"], "w")
        XCTAssertEqual(dictionary["a"], "s")
        XCTAssertEqual(dictionary["z"], "x")
    }
    
}
