// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import XCTest

import Foundation

@testable import VarioqubNetwork






















public class NetworkRequestCreatorMock: NetworkRequestCreator {

    public init() {}



    //MARK: - makeRequest

    public var makeRequestBaseURLExpectation: XCTestExpectation?
    public var makeRequestBaseURLCallsCount = 0
    public var makeRequestBaseURLCalled: Bool {
        return makeRequestBaseURLCallsCount > 0
    }
    public var makeRequestBaseURLReceivedArguments: (request: Request, baseURL: URL)?
    public var makeRequestBaseURLReceivedInvocations: [(request: Request, baseURL: URL)] = []
    public var makeRequestBaseURLReturnValue: NetworkRequestable!
    public var makeRequestBaseURLClosure: ((Request, URL) -> NetworkRequestable)?

    public func makeRequest(_ request: Request, baseURL: URL) -> NetworkRequestable {
        defer { makeRequestBaseURLExpectation?.fulfill() }
        makeRequestBaseURLCallsCount += 1
        makeRequestBaseURLReceivedArguments = (request: request, baseURL: baseURL)
        makeRequestBaseURLReceivedInvocations.append((request: request, baseURL: baseURL))
        if let makeRequestBaseURLClosure = makeRequestBaseURLClosure {
            return makeRequestBaseURLClosure(request, baseURL)
        } else {
            return makeRequestBaseURLReturnValue
        }
    }

}
public class NetworkRequestableMock: NetworkRequestable {

    public init() {}



    //MARK: - execute

    public var executeExpectation: XCTestExpectation?
    public var executeCallsCount = 0
    public var executeCalled: Bool {
        return executeCallsCount > 0
    }
    public var executeReturnValue: NetworkRequestable!
    public var executeClosure: (() -> NetworkRequestable)?

    @discardableResult
    public func execute() -> NetworkRequestable {
        defer { executeExpectation?.fulfill() }
        executeCallsCount += 1
        if let executeClosure = executeClosure {
            return executeClosure()
        } else {
            return executeReturnValue
        }
    }

    //MARK: - onCallback

    public var onCallbackExpectation: XCTestExpectation?
    public var onCallbackCallsCount = 0
    public var onCallbackCalled: Bool {
        return onCallbackCallsCount > 0
    }
    public var onCallbackReceivedCallback: (Callback)?
    public var onCallbackReceivedInvocations: [(Callback)] = []
    public var onCallbackReturnValue: NetworkRequestable!
    public var onCallbackClosure: ((@escaping Callback) -> NetworkRequestable)?

    @discardableResult
    public func onCallback(_ callback: @escaping Callback) -> NetworkRequestable {
        defer { onCallbackExpectation?.fulfill() }
        onCallbackCallsCount += 1
        onCallbackReceivedCallback = callback
        onCallbackReceivedInvocations.append(callback)
        if let onCallbackClosure = onCallbackClosure {
            return onCallbackClosure(callback)
        } else {
            return onCallbackReturnValue
        }
    }

    //MARK: - cancel

    public var cancelExpectation: XCTestExpectation?
    public var cancelCallsCount = 0
    public var cancelCalled: Bool {
        return cancelCallsCount > 0
    }
    public var cancelClosure: (() -> Void)?

    public func cancel() {
        defer { cancelExpectation?.fulfill() }
        cancelCallsCount += 1
        cancelClosure?()
    }

}
class USDataTaskCreatorMock: USDataTaskCreator {




    //MARK: - createDataTask

    var createDataTaskRequestForExpectation: XCTestExpectation?
    var createDataTaskRequestForCallsCount = 0
    var createDataTaskRequestForCalled: Bool {
        return createDataTaskRequestForCallsCount > 0
    }
    var createDataTaskRequestForReceivedArguments: (request: URLRequest, task: USNetworkTaskRequest)?
    var createDataTaskRequestForReceivedInvocations: [(request: URLRequest, task: USNetworkTaskRequest)] = []
    var createDataTaskRequestForReturnValue: URLSessionDataTask!
    var createDataTaskRequestForClosure: ((URLRequest, USNetworkTaskRequest) -> URLSessionDataTask)?

    func createDataTask(request: URLRequest, for task: USNetworkTaskRequest) -> URLSessionDataTask {
        defer { createDataTaskRequestForExpectation?.fulfill() }
        createDataTaskRequestForCallsCount += 1
        createDataTaskRequestForReceivedArguments = (request: request, task: task)
        createDataTaskRequestForReceivedInvocations.append((request: request, task: task))
        if let createDataTaskRequestForClosure = createDataTaskRequestForClosure {
            return createDataTaskRequestForClosure(request, task)
        } else {
            return createDataTaskRequestForReturnValue
        }
    }

}
class USNetworkTaskStoragableMock: USNetworkTaskStoragable {




    //MARK: - insert

    var insertNetworkTaskForExpectation: XCTestExpectation?
    var insertNetworkTaskForCallsCount = 0
    var insertNetworkTaskForCalled: Bool {
        return insertNetworkTaskForCallsCount > 0
    }
    var insertNetworkTaskForReceivedArguments: (networkTask: USNetworkTaskRequest, sessionTask: URLSessionTask)?
    var insertNetworkTaskForReceivedInvocations: [(networkTask: USNetworkTaskRequest, sessionTask: URLSessionTask)] = []
    var insertNetworkTaskForClosure: ((USNetworkTaskRequest, URLSessionTask) -> Void)?

    func insert(networkTask: USNetworkTaskRequest, for sessionTask: URLSessionTask) {
        defer { insertNetworkTaskForExpectation?.fulfill() }
        insertNetworkTaskForCallsCount += 1
        insertNetworkTaskForReceivedArguments = (networkTask: networkTask, sessionTask: sessionTask)
        insertNetworkTaskForReceivedInvocations.append((networkTask: networkTask, sessionTask: sessionTask))
        insertNetworkTaskForClosure?(networkTask, sessionTask)
    }

    //MARK: - remove

    var removeTaskExpectation: XCTestExpectation?
    var removeTaskCallsCount = 0
    var removeTaskCalled: Bool {
        return removeTaskCallsCount > 0
    }
    var removeTaskReceivedTask: URLSessionTask?
    var removeTaskReceivedInvocations: [URLSessionTask] = []
    var removeTaskClosure: ((URLSessionTask) -> Void)?

    func remove(task: URLSessionTask) {
        defer { removeTaskExpectation?.fulfill() }
        removeTaskCallsCount += 1
        removeTaskReceivedTask = task
        removeTaskReceivedInvocations.append(task)
        removeTaskClosure?(task)
    }

}
