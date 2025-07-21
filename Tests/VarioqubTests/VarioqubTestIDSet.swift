
import Foundation
import XCTest
@testable import Varioqub

final class VarioqubTestIDSetTests: XCTestCase {
    
    var testIDSet: VarioqubTestIDSet!
    
    private lazy var sample1Array = [4, 5, 6, 7, 8].map { VarioqubTestID(rawValue: $0) }
    private lazy var sample1Set = Set(sample1Array)
    
    override func setUp() {
        super.setUp()
        
        
    }
    
    func testInit() {
        testIDSet = .init()
        
        XCTAssertEqual(testIDSet.set.count, 0)
    }
    
    func testInitWithSeq() {
        testIDSet = VarioqubTestIDSet(seq: sample1Array)
        
        XCTAssertEqual(testIDSet.set, sample1Set)
    }
    
    func testInitTestId() {
        testIDSet = VarioqubTestIDSet(testIdSet: sample1Set)
        
        XCTAssertEqual(testIDSet.set, sample1Set)
    }
    
    func testAppend() {
        testIDSet = .init()
        
        testIDSet.append(.init(rawValue: 1))
        XCTAssertEqual(testIDSet.set, Set([1]))
        
        testIDSet.append(.init(rawValue: 2))
        XCTAssertEqual(testIDSet.set, Set([1, 2]))
        
        testIDSet.append(.init(rawValue: 1))
        XCTAssertEqual(testIDSet.set, Set([1, 2]))
    }
    
    func testRestrict() {
        testIDSet = .init()
        
        testIDSet.append(.init(rawValue: 1))
        testIDSet.append(.init(rawValue: 2))
        testIDSet.append(.init(rawValue: 3))
        testIDSet.append(.init(rawValue: 4))
        
        testIDSet.restrict([3, 4, 5])
        
        XCTAssertEqual(testIDSet.set, [3, 4])
    }
    
}

