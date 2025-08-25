
import XCTest
@testable import Varioqub

final class FlagControllerTests: XCTestCase {

    var flagController: FlagController!
    var output: FlagResolverInputMock!
    
    override func setUp() {
        output = FlagResolverInputMock()
        flagController = FlagController(
            output: output
        )
    }
    
    func testSimpleUpdateResponse() {
        let response = ResponseDTODataProvider.simpleResponse()
        
        flagController.updateResponse(response)
        
        XCTAssertTrue(output.updateFlagsCalled)
        XCTAssertEqual(output.updateFlagsReceivedOutput, VarioqubFlagsDataProvider.simpleFlags())
        
        XCTAssertTrue(output.updateResourcesCalled)
        XCTAssertEqual(output.updateResourcesReceivedResources, VarioqubFlagsDataProvider.simpleResources())
    }
    
    func testDefaultValue() {
        flagController.updateDefaultValues(ResponseDTODataProvider.simpleDefaultValues())
        
        XCTAssertTrue(output.updateFlagsCalled)
        XCTAssertEqual(output.updateFlagsReceivedOutput, VarioqubFlagsDataProvider.defaultValues())
    }
    
    func testMergeDefaultWithSimple() {
        let response = ResponseDTODataProvider.simpleResponse()
        
        flagController.updateResponse(response)
        flagController.updateDefaultValues(ResponseDTODataProvider.simpleDefaultValues())
        
        XCTAssertTrue(output.updateFlagsCalled)
        XCTAssertEqual(output.updateFlagsReceivedOutput, VarioqubFlagsDataProvider.simpleWithDefaultFlags())
    }
    
    func testConditionsRuntimeUpdateResponse() {
        let response = ResponseDTODataProvider.conditionsResponse()
        
        var params = VarioqubParameters()
        params.setParameter("abc", forKey: "param1")
        flagController.updateRuntimeParams(params)
        flagController.updateResponse(response)
        
        XCTAssertTrue(output.updateFlagsCalled)
        XCTAssertEqual(output.updateFlagsReceivedOutput, VarioqubFlagsDataProvider.param1Flags())
        
        params.setParameter("abc", forKey: "param2")
        flagController.updateRuntimeParams(params)
        XCTAssertEqual(output.updateFlagsReceivedOutput, VarioqubFlagsDataProvider.param2Flags())
    }
    
    func testConditionsDeeplinkUpdateResponse() {
        let response = ResponseDTODataProvider.conditionsResponse()
        
        var params = VarioqubParameters()
        params.setParameter("abc", forKey: "param1")
        flagController.updateDeeplinkParams(params)
        flagController.updateResponse(response)
        
        XCTAssertTrue(output.updateFlagsCalled)
        XCTAssertEqual(output.updateFlagsReceivedOutput, VarioqubFlagsDataProvider.deeplink1Flags())
        
        params.setParameter("abc", forKey: "param2")
        flagController.updateDeeplinkParams(params)
        XCTAssertEqual(output.updateFlagsReceivedOutput, VarioqubFlagsDataProvider.deeplink2Flags())
    }
    
    func testMergeAll() {
        var params = VarioqubParameters()
        params.setParameter("abc", forKey: "param2")
        
        flagController.updateDefaultValues(ResponseDTODataProvider.simpleDefaultValues())
        flagController.updateResponse(ResponseDTODataProvider.simpleAndConditionsResponse())
        flagController.updateRuntimeParams(params)
        flagController.updateDeeplinkParams(params)
        
        
        XCTAssertTrue(output.updateFlagsCalled)
        XCTAssertEqual(output.updateFlagsReceivedOutput, VarioqubFlagsDataProvider.simpleWithAll())
    }

}
