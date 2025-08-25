
import XCTest
@testable import Varioqub
#if VQ_MODULES
import VarioqubUtils
#endif

final class SlotHolderTests: XCTestCase {

    var slotHolder: SlotHolder!
    var settingsMock: VarioqubSettingsMock!
    var outputMock: FlagControllerInputMock!
    var reporterMock: SlotHolderReportableMock!
    
    private let currentDate = Date()
    
    override func setUp() {
        
        settingsMock = VarioqubSettingsMock()
        outputMock = FlagControllerInputMock()
        reporterMock = SlotHolderReportableMock()
        
        slotHolder = SlotHolder(
            settings: settingsMock,
            output: outputMock,
            reporter: reporterMock
        )
    }
    
    func testLoadWithNoData() {
        slotHolder.load()
        
        XCTAssertFalse(outputMock.updateResponseCalled)
    }

    func testLoadWithData() {
        setData(for: "active")
        
        slotHolder.load()
        XCTAssertTrue(outputMock.updateResponseCalled)
        XCTAssertEqual(outputMock.updateResponseReceivedResponse?.id, "simpleId")
        XCTAssertEqual(outputMock.updateResponseReceivedResponse?.configVersion, "simpleConfigVersion")
        XCTAssertEqual(outputMock.updateResponseReceivedResponse?.experimentId, "simpleExperiments")
    }
    
    func testUpdateNetworkData() throws {
        let model = NetworkDataModel(
            version: .current,
            data: PBDataProvider.simpleData(),
            fetchDate: currentDate
        )
        
        try slotHolder.updateNetworkData(model)
        try loadModelDSO(key: "pending") { modelDSO in
            XCTAssertEqual(modelDSO.data, model.data)
            XCTAssertEqual(modelDSO.fetchDate, model.fetchDate)
            XCTAssertEqual(modelDSO.version, model.version.description)
        }
        
        XCTAssertTrue(settingsMock.isShouldNotifyExperimentChanged)
    }
    
    func testUpdateNetworkDataWithMailformedData() {
        let model = NetworkDataModel(
            version: .current,
            data: "some content".data(using: .utf8)!,
            fetchDate: currentDate
        )
        
        XCTAssertThrowsError(try slotHolder.updateNetworkData(model))
        XCTAssertTrue(settingsMock.networkModels.isEmpty)
        XCTAssertTrue(settingsMock.networkDSODict.isEmpty)
    }
    
    func testActivate() throws {
        try setupPendingAndActiveData()
        
        slotHolder.activateConfig()
        
        XCTAssertTrue(outputMock.updateResponseCalled)
        XCTAssertEqual(outputMock.updateResponseReceivedResponse?.configVersion, "simpleConfigVersionp")
        XCTAssertEqual(outputMock.updateResponseReceivedResponse?.experimentId, "simpleExperimentsp")
        XCTAssertEqual(outputMock.updateResponseReceivedResponse?.id, "simpleIdp")
    }
    
    func testActivateRepoter() throws {
        
        let res1 = PBDataProvider.simpleResponse(suffix: "p")
        let res2 = PBDataProvider.simpleResponse(suffix: "a")
        let res3 = PBDataProvider.simpleResponse(suffix: "n")
        
        let data1 = try res1.serializedData()
        let data2 = try res2.serializedData()
        let data3 = try res3.serializedData()
        
        let model1 = NetworkDataModel(
            version: .current,
            data: data1,
            fetchDate: currentDate
        )
        let model2 = NetworkDataModel(
            version: .current,
            data: data2,
            fetchDate: currentDate
        )
        let model3 = NetworkDataModel(
            version: .current,
            data: data3,
            fetchDate: currentDate
        )
        
        try slotHolder.updateNetworkData(model1)
        try slotHolder.updateNetworkData(model2)
        try slotHolder.updateNetworkData(model3)
        
        try slotHolder.updateNetworkData(model1)
        XCTAssertTrue(settingsMock.isShouldNotifyExperimentChanged)
        
        slotHolder.activateConfig()
        XCTAssertFalse(settingsMock.isShouldNotifyExperimentChanged)
        XCTAssertEqual(reporterMock.configAppliedOldConfigNewConfigCallsCount, 1)
        
        try loadModelDSO(key: "active") { model in
            XCTAssertEqual(model.data, data1)
        }
        
        try slotHolder.updateNetworkData(model2)
        try loadModelDSO(key: "pending") { model in
            XCTAssertEqual(model.data, data2)
        }
        XCTAssertTrue(settingsMock.isShouldNotifyExperimentChanged)
        
        slotHolder.activateConfig()
        XCTAssertEqual(reporterMock.configAppliedOldConfigNewConfigCallsCount, 2)
        XCTAssertFalse(settingsMock.isShouldNotifyExperimentChanged)
        
        try loadModelDSO(key: "active") { model in
            XCTAssertEqual(model.data, data2)
        }
        
        try slotHolder.updateNetworkData(model2)
        XCTAssertEqual(reporterMock.configAppliedOldConfigNewConfigCallsCount, 2)
        XCTAssertFalse(settingsMock.isShouldNotifyExperimentChanged)
    }
    
    private func setData(for key: String) {
        let model = NetworkDataDSOv100(
            version: "1.0.0",
            data: PBDataProvider.simpleData(),
            fetchDate: currentDate
        )
        let jsonData = try! JSONEncoder().encode(model)
        settingsMock.storeNetworkModel(jsonData, for: key)
    }
    
    private func setupPendingAndActiveData() throws {
        let res1 = PBDataProvider.simpleResponse(suffix: "p")
        let res2 = PBDataProvider.simpleResponse(suffix: "a")
        
        let data1 = try res1.serializedData()
        let data2 = try res2.serializedData()
        
        let model1 = NetworkDataDSOv100(
            version: "1.0.0",
            data: data1,
            fetchDate: currentDate
        )
        let model2 = NetworkDataDSOv100(
            version: "1.0.0",
            data: data2,
            fetchDate: currentDate
        )
        let modelData1 = try! JSONEncoder().encode(model1)
        let modelData2 = try! JSONEncoder().encode(model2)
        
        settingsMock.storeNetworkModel(modelData1, for: "pending")
        settingsMock.storeNetworkModel(modelData2, for: "active")
    }
    
    private func loadModelDSO(key: String, closure: (_ model: NetworkDataDSOv100) throws -> Void) throws {
        if let data = settingsMock.loadNetworkModel(for: key), !data.isEmpty {
            let model = try JSONDecoder().decode(NetworkDataDSOv100.self, from: data)
            try closure(model)
        } else {
            XCTFail()
        }
    }

}
