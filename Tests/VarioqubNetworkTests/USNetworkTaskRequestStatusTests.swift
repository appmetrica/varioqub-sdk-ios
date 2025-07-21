import XCTest
@testable import VarioqubNetwork
import VarioqubUtils

final class USNetworkTaskRequestStatusTests: XCTestCase {

    let baseURL = URL(string: "https://example.org")!
    let mockExecutor = MockExecutor()
    let stubStorage = USTaskStorageStub()
    let dataTaskCreator = USDataTaskCreatorStub()
    let threadChecker = ThreadChecker()


    let request = Request.get(path: "path")
    let failedRequest = Request.get(path: "")

    func testStatusNotStartedAfterCreation() {
        let taskTest = USNetworkTaskRequest(baseURL: baseURL,
                request: request,
                executor: mockExecutor,
                storage: stubStorage,
                dataTaskCreator: dataTaskCreator,
                threadChecker: threadChecker
        )

        XCTAssertEqual(taskTest.state.wrappedValue, USNetworkTaskState.notStarted)
    }

    func testStatusInProgressAfterExecute() {
        let taskTest = USNetworkTaskRequest(baseURL: baseURL,
                request: request,
                executor: mockExecutor,
                storage: stubStorage,
                dataTaskCreator: dataTaskCreator,
                threadChecker: threadChecker
        )

        taskTest.execute()

        XCTAssertEqual(taskTest.state.wrappedValue, USNetworkTaskState.inProgress)
    }

    func testStatusFinishedIfFailed() {
        let taskTest = USNetworkTaskRequest(baseURL: baseURL,
                request: failedRequest,
                executor: mockExecutor,
                storage: stubStorage,
                dataTaskCreator: dataTaskCreator,
                threadChecker: threadChecker
        )

        taskTest.execute()

        XCTAssertEqual(taskTest.state.wrappedValue, USNetworkTaskState.finished)
    }

    func testStatusFinishedIfCancelled() {
        let taskTest = USNetworkTaskRequest(baseURL: baseURL,
                request: request,
                executor: mockExecutor,
                storage: stubStorage,
                dataTaskCreator: dataTaskCreator,
                threadChecker: threadChecker
        )

        taskTest.execute()
        taskTest.cancel()

        XCTAssertEqual(taskTest.state.wrappedValue, USNetworkTaskState.finished)
    }

}
