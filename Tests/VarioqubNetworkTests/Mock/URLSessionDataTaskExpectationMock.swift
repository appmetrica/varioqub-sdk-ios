import Foundation
import XCTest

final class URLSessionDataTaskExpectationMock: URLSessionDataTask {

    var resumeExpectation: XCTestExpectation!
    var suspendExpectation: XCTestExpectation!
    var cancelExpectation: XCTestExpectation!

    override func resume() {
        resumeExpectation.fulfill()
    }

    override func suspend() {
        suspendExpectation.fulfill()
    }

    override func cancel() {
        cancelExpectation.fulfill()
    }

}
