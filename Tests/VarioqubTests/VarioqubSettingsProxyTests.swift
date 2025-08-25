import XCTest
@testable import Varioqub


final class VarioqubSettingsProxyTests: XCTestCase {

    var proxy: VarioqubSettingsProxy!
    var settings: VarioqubSettingsProtocolMock!
    
    private lazy var reporterDataDSO = ReporterDataDSO(
        testIds: [1, 2, 3, 4, 5],
        experiment: "exp"
    )
    
    private lazy var reporterDataDTO = ReporterDataDTO(
        testIds: VarioqubTestIDSet(seq: [1, 2, 3, 4, 5]),
        experiment: "exp"
    )

    override func setUp() {
        super.setUp()

        settings = VarioqubSettingsProtocolMock()
        proxy = VarioqubSettingsProxy(realSettings: settings)
    }

    func testGetLastFetchDateNil() {
        settings.lastFetchDate = nil

        XCTAssertEqual(proxy.lastFetchDate, Date(timeIntervalSince1970: 0))
    }

    func testGetLastFetchDateNonNil() {
        let d = Date()

        settings.lastFetchDate = d
        XCTAssertEqual(proxy.lastFetchDate, d)
    }

    func testSetLastFetchDate() {
        let d = Date()

        proxy.lastFetchDate = d
        XCTAssertEqual(settings.lastFetchDate, d)
    }
    
    func testGetReporterData() throws {
        settings.reporterData = try JSONEncoder().encode(reporterDataDSO)
        
        let value = proxy.reporterData
        XCTAssertEqual(value, reporterDataDTO)
    }
    
    func testSetReporterData() throws {
        proxy.reporterData = reporterDataDTO
        
        let settingsReporterDSO = try settings.reporterData.map { try JSONDecoder().decode(ReporterDataDSO.self, from: $0) }
        XCTAssertNotNil(settingsReporterDSO)
        XCTAssertEqual(settingsReporterDSO, reporterDataDSO)
    }

}
