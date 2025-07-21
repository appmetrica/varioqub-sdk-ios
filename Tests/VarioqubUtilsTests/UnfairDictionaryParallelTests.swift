import Foundation
import XCTest
@testable import VarioqubUtils

private final class ParallelCounter {
    
    let lock = UnfairLock()
    init() {
    }
    
    var counter: Int = 0
    
    func increaseCounter() {
        lock.lock {
            counter += 1
        }
    }
}

final class UnfairDictionaryParallelTests: XCTestCase {
    
    private var dictionary: UnfairDictionary<String, ParallelCounter>!
    
    override func setUp() {
        super.setUp()

        dictionary = UnfairDictionary<String, ParallelCounter>()
    }
    
    func testGetOrPutParallel() {
        let queueCount = 10
        let iterationCount = 10000
        
        let dictionary: UnfairDictionary<String, ParallelCounter> = self.dictionary
        
        let dispatchGroup = DispatchGroup()
        let creationCounter = ParallelCounter()
        
        
        let closure: () -> () = {
            for i in 0..<iterationCount {
                let result = dictionary.getOrPut(key: "key_\(i)") {
                    creationCounter.increaseCounter()
                    return ParallelCounter()
                }
                result.increaseCounter()
            }
            dispatchGroup.leave()
        }
        
        let queues = (0..<queueCount).map {
            DispatchQueue(label: "Queue-\($0)")
        }
        
        queues.forEach {
            dispatchGroup.enter()
            $0.execute(closure)
        }
        
        _ = dispatchGroup.wait(timeout: .now() + .seconds(100))
        
        XCTAssertEqual(dictionary.count, iterationCount)
        XCTAssertEqual(creationCounter.counter, iterationCount)
        for i in 0..<iterationCount {
            let item = dictionary["key_\(i)"]
            XCTAssertEqual(item?.counter, queueCount)
        }
    }
    
}
