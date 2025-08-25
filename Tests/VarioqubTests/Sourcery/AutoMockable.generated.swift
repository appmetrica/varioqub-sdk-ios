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
class ConfigFetcherOutputMock: ConfigFetcherOutput {




    //MARK: - updateNetworkData

    var updateNetworkDataThrowableError: Error?
    var updateNetworkDataExpectation: XCTestExpectation?
    var updateNetworkDataCallsCount = 0
    var updateNetworkDataCalled: Bool {
        return updateNetworkDataCallsCount > 0
    }
    var updateNetworkDataReceivedModel: NetworkDataModel?
    var updateNetworkDataReceivedInvocations: [NetworkDataModel] = []
    var updateNetworkDataClosure: ((NetworkDataModel) throws -> Void)?

    func updateNetworkData(_ model: NetworkDataModel) throws {
        defer { updateNetworkDataExpectation?.fulfill() }
        if let error = updateNetworkDataThrowableError {
            throw error
        }
        updateNetworkDataCallsCount += 1
        updateNetworkDataReceivedModel = model
        updateNetworkDataReceivedInvocations.append(model)
        try updateNetworkDataClosure?(model)
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
class FlagControllerInputMock: FlagControllerInput {




    //MARK: - updateResponse

    var updateResponseExpectation: XCTestExpectation?
    var updateResponseCallsCount = 0
    var updateResponseCalled: Bool {
        return updateResponseCallsCount > 0
    }
    var updateResponseReceivedResponse: ResponseDTO?
    var updateResponseReceivedInvocations: [ResponseDTO] = []
    var updateResponseClosure: ((ResponseDTO) -> Void)?

    func updateResponse(_ response: ResponseDTO) {
        defer { updateResponseExpectation?.fulfill() }
        updateResponseCallsCount += 1
        updateResponseReceivedResponse = response
        updateResponseReceivedInvocations.append(response)
        updateResponseClosure?(response)
    }

}
class FlagControllerParamsInputMock: FlagControllerParamsInput {




    //MARK: - updateRuntimeParams

    var updateRuntimeParamsExpectation: XCTestExpectation?
    var updateRuntimeParamsCallsCount = 0
    var updateRuntimeParamsCalled: Bool {
        return updateRuntimeParamsCallsCount > 0
    }
    var updateRuntimeParamsReceivedParams: VarioqubParameters?
    var updateRuntimeParamsReceivedInvocations: [VarioqubParameters] = []
    var updateRuntimeParamsClosure: ((VarioqubParameters) -> Void)?

    func updateRuntimeParams(_ params: VarioqubParameters) {
        defer { updateRuntimeParamsExpectation?.fulfill() }
        updateRuntimeParamsCallsCount += 1
        updateRuntimeParamsReceivedParams = params
        updateRuntimeParamsReceivedInvocations.append(params)
        updateRuntimeParamsClosure?(params)
    }

    //MARK: - updateDeeplinkParams

    var updateDeeplinkParamsExpectation: XCTestExpectation?
    var updateDeeplinkParamsCallsCount = 0
    var updateDeeplinkParamsCalled: Bool {
        return updateDeeplinkParamsCallsCount > 0
    }
    var updateDeeplinkParamsReceivedParams: VarioqubParameters?
    var updateDeeplinkParamsReceivedInvocations: [VarioqubParameters] = []
    var updateDeeplinkParamsClosure: ((VarioqubParameters) -> Void)?

    func updateDeeplinkParams(_ params: VarioqubParameters) {
        defer { updateDeeplinkParamsExpectation?.fulfill() }
        updateDeeplinkParamsCallsCount += 1
        updateDeeplinkParamsReceivedParams = params
        updateDeeplinkParamsReceivedInvocations.append(params)
        updateDeeplinkParamsClosure?(params)
    }

    //MARK: - updateDefaultValues

    var updateDefaultValuesExpectation: XCTestExpectation?
    var updateDefaultValuesCallsCount = 0
    var updateDefaultValuesCalled: Bool {
        return updateDefaultValuesCallsCount > 0
    }
    var updateDefaultValuesReceivedDefaultValues: [VarioqubFlag: VarioqubValue]?
    var updateDefaultValuesReceivedInvocations: [[VarioqubFlag: VarioqubValue]] = []
    var updateDefaultValuesClosure: (([VarioqubFlag: VarioqubValue]) -> Void)?

    func updateDefaultValues(_ defaultValues: [VarioqubFlag: VarioqubValue]) {
        defer { updateDefaultValuesExpectation?.fulfill() }
        updateDefaultValuesCallsCount += 1
        updateDefaultValuesReceivedDefaultValues = defaultValues
        updateDefaultValuesReceivedInvocations.append(defaultValues)
        updateDefaultValuesClosure?(defaultValues)
    }

}
class FlagResolverInputMock: FlagResolverInput {




    //MARK: - updateResources

    var updateResourcesExpectation: XCTestExpectation?
    var updateResourcesCallsCount = 0
    var updateResourcesCalled: Bool {
        return updateResourcesCallsCount > 0
    }
    var updateResourcesReceivedResources: [VarioqubResourceKey: VarioqubResource]?
    var updateResourcesReceivedInvocations: [[VarioqubResourceKey: VarioqubResource]] = []
    var updateResourcesClosure: (([VarioqubResourceKey: VarioqubResource]) -> Void)?

    func updateResources(_ resources: [VarioqubResourceKey: VarioqubResource]) {
        defer { updateResourcesExpectation?.fulfill() }
        updateResourcesCallsCount += 1
        updateResourcesReceivedResources = resources
        updateResourcesReceivedInvocations.append(resources)
        updateResourcesClosure?(resources)
    }

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
class SlotHolderControlableMock: SlotHolderControlable {




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
class SlotHolderInputMock: SlotHolderInput {




    //MARK: - loadPendingData

    var loadPendingDataExpectation: XCTestExpectation?
    var loadPendingDataCallsCount = 0
    var loadPendingDataCalled: Bool {
        return loadPendingDataCallsCount > 0
    }
    var loadPendingDataReturnValue: NetworkDataModel!
    var loadPendingDataClosure: (() -> NetworkDataModel)?

    func loadPendingData() -> NetworkDataModel {
        defer { loadPendingDataExpectation?.fulfill() }
        loadPendingDataCallsCount += 1
        if let loadPendingDataClosure = loadPendingDataClosure {
            return loadPendingDataClosure()
        } else {
            return loadPendingDataReturnValue
        }
    }

}
class SlotHolderReportableMock: SlotHolderReportable {




    //MARK: - configApplied

    var configAppliedOldConfigNewConfigExpectation: XCTestExpectation?
    var configAppliedOldConfigNewConfigCallsCount = 0
    var configAppliedOldConfigNewConfigCalled: Bool {
        return configAppliedOldConfigNewConfigCallsCount > 0
    }
    var configAppliedOldConfigNewConfigReceivedArguments: (oldConfig: SlotHolderConfigModel?, newConfig: SlotHolderConfigModel)?
    var configAppliedOldConfigNewConfigReceivedInvocations: [(oldConfig: SlotHolderConfigModel?, newConfig: SlotHolderConfigModel)] = []
    var configAppliedOldConfigNewConfigClosure: ((SlotHolderConfigModel?, SlotHolderConfigModel) -> Void)?

    func configApplied(oldConfig: SlotHolderConfigModel?, newConfig: SlotHolderConfigModel) {
        defer { configAppliedOldConfigNewConfigExpectation?.fulfill() }
        configAppliedOldConfigNewConfigCallsCount += 1
        configAppliedOldConfigNewConfigReceivedArguments = (oldConfig: oldConfig, newConfig: newConfig)
        configAppliedOldConfigNewConfigReceivedInvocations.append((oldConfig: oldConfig, newConfig: newConfig))
        configAppliedOldConfigNewConfigClosure?(oldConfig, newConfig)
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
public class VarioqubRuntimeOptionableMock: VarioqubRuntimeOptionable {

    public init() {}

    public var sendEventOnChangeConfig: Bool {
        get { return underlyingSendEventOnChangeConfig }
        set(value) { underlyingSendEventOnChangeConfig = value }
    }
    public var underlyingSendEventOnChangeConfig: Bool!
    public var clientFeatures: VarioqubClientFeatures {
        get { return underlyingClientFeatures }
        set(value) { underlyingClientFeatures = value }
    }
    public var underlyingClientFeatures: VarioqubClientFeatures!
    public var runtimeParams: VarioqubParameters {
        get { return underlyingRuntimeParams }
        set(value) { underlyingRuntimeParams = value }
    }
    public var underlyingRuntimeParams: VarioqubParameters!


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


    //MARK: - storeNetworkModel

    public var storeNetworkModelForExpectation: XCTestExpectation?
    public var storeNetworkModelForCallsCount = 0
    public var storeNetworkModelForCalled: Bool {
        return storeNetworkModelForCallsCount > 0
    }
    public var storeNetworkModelForReceivedArguments: (data: Data?, key: String)?
    public var storeNetworkModelForReceivedInvocations: [(data: Data?, key: String)] = []
    public var storeNetworkModelForClosure: ((Data?, String) -> Void)?

    public func storeNetworkModel(_ data: Data?, for key: String) {
        defer { storeNetworkModelForExpectation?.fulfill() }
        storeNetworkModelForCallsCount += 1
        storeNetworkModelForReceivedArguments = (data: data, key: key)
        storeNetworkModelForReceivedInvocations.append((data: data, key: key))
        storeNetworkModelForClosure?(data, key)
    }

    //MARK: - loadNetworkModel

    public var loadNetworkModelForExpectation: XCTestExpectation?
    public var loadNetworkModelForCallsCount = 0
    public var loadNetworkModelForCalled: Bool {
        return loadNetworkModelForCallsCount > 0
    }
    public var loadNetworkModelForReceivedKey: String?
    public var loadNetworkModelForReceivedInvocations: [String] = []
    public var loadNetworkModelForReturnValue: Data?
    public var loadNetworkModelForClosure: ((String) -> Data?)?

    public func loadNetworkModel(for key: String) -> Data? {
        defer { loadNetworkModelForExpectation?.fulfill() }
        loadNetworkModelForCallsCount += 1
        loadNetworkModelForReceivedKey = key
        loadNetworkModelForReceivedInvocations.append(key)
        if let loadNetworkModelForClosure = loadNetworkModelForClosure {
            return loadNetworkModelForClosure(key)
        } else {
            return loadNetworkModelForReturnValue
        }
    }

    //MARK: - storeNetworkDSOv0

    public var storeNetworkDSOv0ForExpectation: XCTestExpectation?
    public var storeNetworkDSOv0ForCallsCount = 0
    public var storeNetworkDSOv0ForCalled: Bool {
        return storeNetworkDSOv0ForCallsCount > 0
    }
    public var storeNetworkDSOv0ForReceivedArguments: (data: Data?, key: String)?
    public var storeNetworkDSOv0ForReceivedInvocations: [(data: Data?, key: String)] = []
    public var storeNetworkDSOv0ForClosure: ((Data?, String) -> Void)?

    public func storeNetworkDSOv0(_ data: Data?, for key: String) {
        defer { storeNetworkDSOv0ForExpectation?.fulfill() }
        storeNetworkDSOv0ForCallsCount += 1
        storeNetworkDSOv0ForReceivedArguments = (data: data, key: key)
        storeNetworkDSOv0ForReceivedInvocations.append((data: data, key: key))
        storeNetworkDSOv0ForClosure?(data, key)
    }

    //MARK: - loadNetworkDSOv0

    public var loadNetworkDSOv0ForExpectation: XCTestExpectation?
    public var loadNetworkDSOv0ForCallsCount = 0
    public var loadNetworkDSOv0ForCalled: Bool {
        return loadNetworkDSOv0ForCallsCount > 0
    }
    public var loadNetworkDSOv0ForReceivedKey: String?
    public var loadNetworkDSOv0ForReceivedInvocations: [String] = []
    public var loadNetworkDSOv0ForReturnValue: Data?
    public var loadNetworkDSOv0ForClosure: ((String) -> Data?)?

    public func loadNetworkDSOv0(for key: String) -> Data? {
        defer { loadNetworkDSOv0ForExpectation?.fulfill() }
        loadNetworkDSOv0ForCallsCount += 1
        loadNetworkDSOv0ForReceivedKey = key
        loadNetworkDSOv0ForReceivedInvocations.append(key)
        if let loadNetworkDSOv0ForClosure = loadNetworkDSOv0ForClosure {
            return loadNetworkDSOv0ForClosure(key)
        } else {
            return loadNetworkDSOv0ForReturnValue
        }
    }

}
