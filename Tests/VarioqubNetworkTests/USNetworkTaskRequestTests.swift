import XCTest
import Foundation
@testable import VarioqubNetwork
import VarioqubUtils

final class USNetworkTaskRequestTests: XCTestCase {

    let baseURL = URL(string: "https://example.org")!
    let mockExecutor = MockExecutor()
    let dataTaskStub = URLSessionDataTaskStub()
    let validRequest = Request.get(path: "path")
    let errorRequest = Request.get(path: "")
    let threadChecker = ThreadChecker()

    let mockError = MockError(text: "network error")

    private let validAnswer = "valid answer".data(using: .utf8)!
    private let validResponse = HTTPURLResponse(
            url: URL(string: "https://example.org/path")!,
            statusCode: 200,
            httpVersion: "1.2",
            headerFields: [:]
    )

    private let serverErrorResponse = HTTPURLResponse(
            url: URL(string: "https://example.org/path")!,
            statusCode: 401,
            httpVersion: "1.2",
            headerFields: [:]
    )

    var storageMock: USNetworkTaskStoragableMock!
    var creatorMock: USDataTaskCreatorMock!
    var dataTaskMock: URLSessionDataTaskExpectationMock!

    override func setUp() {
        super.setUp()

        dataTaskMock = URLSessionDataTaskExpectationMock()

        storageMock = USNetworkTaskStoragableMock()

        creatorMock = USDataTaskCreatorMock()
        creatorMock.createDataTaskRequestForReturnValue = dataTaskMock

    }

    func testValidRequestCalling() {

        let task = USNetworkTaskRequest(baseURL: baseURL,
                request: validRequest,
                executor: mockExecutor,
                storage: storageMock,
                dataTaskCreator: creatorMock,
                threadChecker: threadChecker
        )

        storageMock.insertNetworkTaskForExpectation = expectation(description: "insertNetworkTaskForExpectation")
        creatorMock.createDataTaskRequestForExpectation = expectation(description: "createDataTaskRequestForExpectation")
        dataTaskMock.resumeExpectation = expectation(description: "resumeExpectation")

        task.execute()

        waitForExpectations(timeout: 1)

        XCTAssertEqual(storageMock.insertNetworkTaskForCallsCount, 1)
        XCTAssertEqual(storageMock.removeTaskCallsCount, 0)
        XCTAssertEqual(creatorMock.createDataTaskRequestForCallsCount, 1)

    }

    func testErrorRequestCalling() {

        let task = USNetworkTaskRequest(baseURL: baseURL,
                request: errorRequest,
                executor: mockExecutor,
                storage: storageMock,
                dataTaskCreator: creatorMock,
                threadChecker: threadChecker
        )

        let callbackExpectation = expectation(description: "callback")
        task.onCallback { result in
            callbackExpectation.fulfill()
            switch result {
            case .networkError(let e):
                switch e {
                case .urlEncodingError:
                    break
                default:
                    XCTAssert(false)
                }
            default:
                XCTAssert(false)
            }
        }
        task.execute()

        waitForExpectations(timeout: 1)

        XCTAssertEqual(storageMock.insertNetworkTaskForCallsCount, 0)
        XCTAssertEqual(storageMock.removeTaskCallsCount, 0)
        XCTAssertEqual(creatorMock.createDataTaskRequestForCallsCount, 0)

    }

    func testValidAnswer() {
        creatorMock.createDataTaskRequestForReturnValue = dataTaskStub

        let task = USNetworkTaskRequest(baseURL: baseURL,
                request: validRequest,
                executor: mockExecutor,
                storage: storageMock,
                dataTaskCreator: creatorMock,
                threadChecker: threadChecker
        )

        let callbackExpectation = expectation(description: "callback")

        task.onCallback { [validAnswer] in
            callbackExpectation.fulfill()
            switch $0 {
            case .validAnswer(let ans):
                XCTAssertEqual(ans.body, validAnswer)
            default:
                XCTAssert(false)
            }
        }
        task.execute()
        task.handleAnswer(data: validAnswer, response: validResponse, error: nil)

        waitForExpectations(timeout: 1)
    }

    func testServerErrorAnswer() {
        creatorMock.createDataTaskRequestForReturnValue = dataTaskStub

        let task = USNetworkTaskRequest(baseURL: baseURL,
                request: validRequest,
                executor: mockExecutor,
                storage: storageMock,
                dataTaskCreator: creatorMock,
                threadChecker: threadChecker
        )

        let callbackExpectation = expectation(description: "callback")

        task.onCallback { [validAnswer] in
            callbackExpectation.fulfill()
            switch $0 {
            case .serverError(let ans):
                XCTAssertEqual(ans.body, validAnswer)
            default:
                XCTAssert(false)
            }
        }
        task.execute()
        task.handleAnswer(data: validAnswer, response: serverErrorResponse, error: nil)

        waitForExpectations(timeout: 1)
    }

    func testNetworkErrorAnswer() {
        creatorMock.createDataTaskRequestForReturnValue = dataTaskStub

        let task = USNetworkTaskRequest(baseURL: baseURL,
                request: validRequest,
                executor: mockExecutor,
                storage: storageMock,
                dataTaskCreator: creatorMock,
                threadChecker: threadChecker
        )

        let callbackExpectation = expectation(description: "callback")

        task.onCallback { [mockError] in
            callbackExpectation.fulfill()
            switch $0 {
            case .networkError(let e):
                switch e {
                case .connectionError(let ce):
                    XCTAssertEqual(ce as? MockError, mockError)
                default:
                    XCTAssert(false)
                }
            default:
                XCTAssert(false)
            }
        }
        task.execute()
        task.handleAnswer(data: nil, response: nil, error: mockError)

        waitForExpectations(timeout: 1)
    }

}
