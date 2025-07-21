// Generated using Sourcery 1.9.2 — https://github.com/krzysztofzablocki/Sourcery
// DO NOT EDIT
// swiftlint:disable line_length
// swiftlint:disable variable_name

import XCTest

import Foundation

@testable import Varioqub
@testable import VarioqubNetwork






















class ConfigFetchableMock: ConfigFetchable {




    //MARK: - fetchExperiments

    var fetchExperimentsCallbackExpectation: XCTestExpectation?
    var fetchExperimentsCallbackCallsCount = 0
    var fetchExperimentsCallbackCalled: Bool {
        return fetchExperimentsCallbackCallsCount > 0
    }
    var fetchExperimentsCallbackClosure: ((ConfigFetchCallback?) -> Void)?

    func fetchExperiments(callback: ConfigFetchCallback?) {
        defer { fetchExperimentsCallbackExpectation?.fulfill() }
        fetchExperimentsCallbackCallsCount += 1
        fetchExperimentsCallbackClosure?(callback)
    }

}
class ConfigFetcherSettingsMock: ConfigFetcherSettings {


    var lastFetchDate: Date {
        get { return underlyingLastFetchDate }
        set(value) { underlyingLastFetchDate = value }
    }
    var underlyingLastFetchDate: Date!
    var etag: String?


}
class ConfigUpdaterControllableMock: ConfigUpdaterControllable {




    //MARK: - activateConfig

    var activateConfigExpectation: XCTestExpectation?
    var activateConfigCallsCount = 0
    var activateConfigCalled: Bool {
        return activateConfigCallsCount > 0
    }
    var activateConfigClosure: (() -> Void)?

    func activateConfig() {
        defer { activateConfigExpectation?.fulfill() }
        activateConfigCallsCount += 1
        activateConfigClosure?()
    }

}
class ConfigUpdaterFlagReporterMock: ConfigUpdaterFlagReporter {




    //MARK: - configApplied

    var configAppliedOldConfigNewConfigExpectation: XCTestExpectation?
    var configAppliedOldConfigNewConfigCallsCount = 0
    var configAppliedOldConfigNewConfigCalled: Bool {
        return configAppliedOldConfigNewConfigCallsCount > 0
    }
    var configAppliedOldConfigNewConfigReceivedArguments: (oldConfig: NetworkData?, newConfig: NetworkData)?
    var configAppliedOldConfigNewConfigReceivedInvocations: [(oldConfig: NetworkData?, newConfig: NetworkData)] = []
    var configAppliedOldConfigNewConfigClosure: ((NetworkData?, NetworkData) -> Void)?

    func configApplied(oldConfig: NetworkData?, newConfig: NetworkData) {
        defer { configAppliedOldConfigNewConfigExpectation?.fulfill() }
        configAppliedOldConfigNewConfigCallsCount += 1
        configAppliedOldConfigNewConfigReceivedArguments = (oldConfig: oldConfig, newConfig: newConfig)
        configAppliedOldConfigNewConfigReceivedInvocations.append((oldConfig: oldConfig, newConfig: newConfig))
        configAppliedOldConfigNewConfigClosure?(oldConfig, newConfig)
    }

}
class ConfigUpdaterInputMock: ConfigUpdaterInput {




    //MARK: - updateNetworkData

    var updateNetworkDataExpectation: XCTestExpectation?
    var updateNetworkDataCallsCount = 0
    var updateNetworkDataCalled: Bool {
        return updateNetworkDataCallsCount > 0
    }
    var updateNetworkDataReceivedData: NetworkData?
    var updateNetworkDataReceivedInvocations: [NetworkData] = []
    var updateNetworkDataClosure: ((NetworkData) -> Void)?

    func updateNetworkData(_ data: NetworkData) {
        defer { updateNetworkDataExpectation?.fulfill() }
        updateNetworkDataCallsCount += 1
        updateNetworkDataReceivedData = data
        updateNetworkDataReceivedInvocations.append(data)
        updateNetworkDataClosure?(data)
    }

    //MARK: - updateDefaultsFlags

    var updateDefaultsFlagsExpectation: XCTestExpectation?
    var updateDefaultsFlagsCallsCount = 0
    var updateDefaultsFlagsCalled: Bool {
        return updateDefaultsFlagsCallsCount > 0
    }
    var updateDefaultsFlagsReceivedFlags: [VarioqubFlag: VarioqubValue]?
    var updateDefaultsFlagsReceivedInvocations: [[VarioqubFlag: VarioqubValue]] = []
    var updateDefaultsFlagsClosure: (([VarioqubFlag: VarioqubValue]) -> Void)?

    func updateDefaultsFlags(_ flags: [VarioqubFlag: VarioqubValue]) {
        defer { updateDefaultsFlagsExpectation?.fulfill() }
        updateDefaultsFlagsCallsCount += 1
        updateDefaultsFlagsReceivedFlags = flags
        updateDefaultsFlagsReceivedInvocations.append(flags)
        updateDefaultsFlagsClosure?(flags)
    }

}
class ConfigUpdaterOutputMock: ConfigUpdaterOutput {




    //MARK: - updateFlags

    var updateFlagsExpectation: XCTestExpectation?
    var updateFlagsCallsCount = 0
    var updateFlagsCalled: Bool {
        return updateFlagsCallsCount > 0
    }
    var updateFlagsReceivedOutput: [VarioqubFlag: VarioqubConfigValue]?
    var updateFlagsReceivedInvocations: [[VarioqubFlag: VarioqubConfigValue]] = []
    var updateFlagsClosure: (([VarioqubFlag: VarioqubConfigValue]) -> Void)?

    func updateFlags(_ output: [VarioqubFlag: VarioqubConfigValue]) {
        defer { updateFlagsExpectation?.fulfill() }
        updateFlagsCallsCount += 1
        updateFlagsReceivedOutput = output
        updateFlagsReceivedInvocations.append(output)
        updateFlagsClosure?(output)
    }

}
class FlagResolverOutputMock: FlagResolverOutput {




    //MARK: - testIdTriggered

    var testIdTriggeredExpectation: XCTestExpectation?
    var testIdTriggeredCallsCount = 0
    var testIdTriggeredCalled: Bool {
        return testIdTriggeredCallsCount > 0
    }
    var testIdTriggeredReceivedTestId: VarioqubTestID?
    var testIdTriggeredReceivedInvocations: [VarioqubTestID] = []
    var testIdTriggeredClosure: ((VarioqubTestID) -> Void)?

    func testIdTriggered(_ testId: VarioqubTestID) {
        defer { testIdTriggeredExpectation?.fulfill() }
        testIdTriggeredCallsCount += 1
        testIdTriggeredReceivedTestId = testId
        testIdTriggeredReceivedInvocations.append(testId)
        testIdTriggeredClosure?(testId)
    }

}
class NetworkDataStorableMock: NetworkDataStorable {


    var isShouldNotifyExperimentChanged: Bool {
        get { return underlyingIsShouldNotifyExperimentChanged }
        set(value) { underlyingIsShouldNotifyExperimentChanged = value }
    }
    var underlyingIsShouldNotifyExperimentChanged: Bool!


    //MARK: - saveNetworkData

    var saveNetworkDataForExpectation: XCTestExpectation?
    var saveNetworkDataForCallsCount = 0
    var saveNetworkDataForCalled: Bool {
        return saveNetworkDataForCallsCount > 0
    }
    var saveNetworkDataForReceivedArguments: (data: NetworkDataDTO?, key: NetworkDataKey)?
    var saveNetworkDataForReceivedInvocations: [(data: NetworkDataDTO?, key: NetworkDataKey)] = []
    var saveNetworkDataForClosure: ((NetworkDataDTO?, NetworkDataKey) -> Void)?

    func saveNetworkData(_ data: NetworkDataDTO?, for key: NetworkDataKey) {
        defer { saveNetworkDataForExpectation?.fulfill() }
        saveNetworkDataForCallsCount += 1
        saveNetworkDataForReceivedArguments = (data: data, key: key)
        saveNetworkDataForReceivedInvocations.append((data: data, key: key))
        saveNetworkDataForClosure?(data, key)
    }

    //MARK: - loadNetworkData

    var loadNetworkDataForExpectation: XCTestExpectation?
    var loadNetworkDataForCallsCount = 0
    var loadNetworkDataForCalled: Bool {
        return loadNetworkDataForCallsCount > 0
    }
    var loadNetworkDataForReceivedKey: NetworkDataKey?
    var loadNetworkDataForReceivedInvocations: [NetworkDataKey] = []
    var loadNetworkDataForReturnValue: NetworkDataDTO?
    var loadNetworkDataForClosure: ((NetworkDataKey) -> NetworkDataDTO?)?

    func loadNetworkData(for key: NetworkDataKey) -> NetworkDataDTO? {
        defer { loadNetworkDataForExpectation?.fulfill() }
        loadNetworkDataForCallsCount += 1
        loadNetworkDataForReceivedKey = key
        loadNetworkDataForReceivedInvocations.append(key)
        if let loadNetworkDataForClosure = loadNetworkDataForClosure {
            return loadNetworkDataForClosure(key)
        } else {
            return loadNetworkDataForReturnValue
        }
    }

}
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
public class RuntimeOptionableMock: RuntimeOptionable {

    public init() {}

    public var sendEventOnChangeConfig: Bool {
        get { return underlyingSendEventOnChangeConfig }
        set(value) { underlyingSendEventOnChangeConfig = value }
    }
    public var underlyingSendEventOnChangeConfig: Bool!
    public var clientFeatures: ClientFeatures {
        get { return underlyingClientFeatures }
        set(value) { underlyingClientFeatures = value }
    }
    public var underlyingClientFeatures: ClientFeatures!


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
public class VarioqubReporterMock: VarioqubReporter {

    public init() {}

    public var varioqubName: String {
        get { return underlyingVarioqubName }
        set(value) { underlyingVarioqubName = value }
    }
    public var underlyingVarioqubName: String!


    //MARK: - setExperiments

    public var setExperimentsExpectation: XCTestExpectation?
    public var setExperimentsCallsCount = 0
    public var setExperimentsCalled: Bool {
        return setExperimentsCallsCount > 0
    }
    public var setExperimentsReceivedExperiments: String?
    public var setExperimentsReceivedInvocations: [String] = []
    public var setExperimentsClosure: ((String) -> Void)?

    public func setExperiments(_ experiments: String) {
        defer { setExperimentsExpectation?.fulfill() }
        setExperimentsCallsCount += 1
        setExperimentsReceivedExperiments = experiments
        setExperimentsReceivedInvocations.append(experiments)
        setExperimentsClosure?(experiments)
    }

    //MARK: - setTriggeredTestIds

    public var setTriggeredTestIdsExpectation: XCTestExpectation?
    public var setTriggeredTestIdsCallsCount = 0
    public var setTriggeredTestIdsCalled: Bool {
        return setTriggeredTestIdsCallsCount > 0
    }
    public var setTriggeredTestIdsReceivedTriggeredTestIds: VarioqubTestIDSet?
    public var setTriggeredTestIdsReceivedInvocations: [VarioqubTestIDSet] = []
    public var setTriggeredTestIdsClosure: ((VarioqubTestIDSet) -> Void)?

    public func setTriggeredTestIds(_ triggeredTestIds: VarioqubTestIDSet) {
        defer { setTriggeredTestIdsExpectation?.fulfill() }
        setTriggeredTestIdsCallsCount += 1
        setTriggeredTestIdsReceivedTriggeredTestIds = triggeredTestIds
        setTriggeredTestIdsReceivedInvocations.append(triggeredTestIds)
        setTriggeredTestIdsClosure?(triggeredTestIds)
    }

    //MARK: - sendActivateEvent

    public var sendActivateEventExpectation: XCTestExpectation?
    public var sendActivateEventCallsCount = 0
    public var sendActivateEventCalled: Bool {
        return sendActivateEventCallsCount > 0
    }
    public var sendActivateEventReceivedEventData: VarioqubEventData?
    public var sendActivateEventReceivedInvocations: [VarioqubEventData] = []
    public var sendActivateEventClosure: ((VarioqubEventData) -> Void)?

    public func sendActivateEvent(_ eventData: VarioqubEventData) {
        defer { sendActivateEventExpectation?.fulfill() }
        sendActivateEventCallsCount += 1
        sendActivateEventReceivedEventData = eventData
        sendActivateEventReceivedInvocations.append(eventData)
        sendActivateEventClosure?(eventData)
    }

}
public class VarioqubSettingsFactoryMock: VarioqubSettingsFactory {

    public init() {}



    //MARK: - createSettings

    public var createSettingsForExpectation: XCTestExpectation?
    public var createSettingsForCallsCount = 0
    public var createSettingsForCalled: Bool {
        return createSettingsForCallsCount > 0
    }
    public var createSettingsForReceivedClientId: String?
    public var createSettingsForReceivedInvocations: [String] = []
    public var createSettingsForReturnValue: VarioqubSettingsProtocol!
    public var createSettingsForClosure: ((String) -> VarioqubSettingsProtocol)?

    public func createSettings(for clientId: String) -> VarioqubSettingsProtocol {
        defer { createSettingsForExpectation?.fulfill() }
        createSettingsForCallsCount += 1
        createSettingsForReceivedClientId = clientId
        createSettingsForReceivedInvocations.append(clientId)
        if let createSettingsForClosure = createSettingsForClosure {
            return createSettingsForClosure(clientId)
        } else {
            return createSettingsForReturnValue
        }
    }

}
public class VarioqubSettingsProtocolMock: VarioqubSettingsProtocol {

    public init() {}

    public var lastFetchDate: Date?
    public var isShouldNotifyExperimentChanged: Bool {
        get { return underlyingIsShouldNotifyExperimentChanged }
        set(value) { underlyingIsShouldNotifyExperimentChanged = value }
    }
    public var underlyingIsShouldNotifyExperimentChanged: Bool!
    public var lastEtag: String?
    public var reporterData: Data?


    //MARK: - storeNetworkData

    public var storeNetworkDataForExpectation: XCTestExpectation?
    public var storeNetworkDataForCallsCount = 0
    public var storeNetworkDataForCalled: Bool {
        return storeNetworkDataForCallsCount > 0
    }
    public var storeNetworkDataForReceivedArguments: (data: Data?, key: String)?
    public var storeNetworkDataForReceivedInvocations: [(data: Data?, key: String)] = []
    public var storeNetworkDataForClosure: ((Data?, String) -> Void)?

    public func storeNetworkData(_ data: Data?, for key: String) {
        defer { storeNetworkDataForExpectation?.fulfill() }
        storeNetworkDataForCallsCount += 1
        storeNetworkDataForReceivedArguments = (data: data, key: key)
        storeNetworkDataForReceivedInvocations.append((data: data, key: key))
        storeNetworkDataForClosure?(data, key)
    }

    //MARK: - loadNetworkData

    public var loadNetworkDataForExpectation: XCTestExpectation?
    public var loadNetworkDataForCallsCount = 0
    public var loadNetworkDataForCalled: Bool {
        return loadNetworkDataForCallsCount > 0
    }
    public var loadNetworkDataForReceivedKey: String?
    public var loadNetworkDataForReceivedInvocations: [String] = []
    public var loadNetworkDataForReturnValue: Data?
    public var loadNetworkDataForClosure: ((String) -> Data?)?

    public func loadNetworkData(for key: String) -> Data? {
        defer { loadNetworkDataForExpectation?.fulfill() }
        loadNetworkDataForCallsCount += 1
        loadNetworkDataForReceivedKey = key
        loadNetworkDataForReceivedInvocations.append(key)
        if let loadNetworkDataForClosure = loadNetworkDataForClosure {
            return loadNetworkDataForClosure(key)
        } else {
            return loadNetworkDataForReturnValue
        }
    }

}
