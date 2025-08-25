
import Foundation
@testable import Varioqub

enum PBDataProvider {
    
    static func simpleData(suffix: String = "") -> Data {
        return try! simpleResponse(suffix: suffix).serializedData()
    }
    
    static func simpleResponse(suffix: String = "") -> PBResponse {
        return PBResponse.with {
            $0.experiments = "simpleExperiments\(suffix)"
            $0.id = "simpleId\(suffix)"
            $0.configVersion = "simpleConfigVersion\(suffix)"
            $0.resources = self.resources()
            $0.flags = self.simpleFlags()
        }
    }
    
    static func resources() -> [PBResource] {
        return [
            PBResource.with {
                $0.key = "key1"
                $0.value = "value1"
                $0.type = "string"
            },
            PBResource.with {
                $0.key = "key2"
                $0.value = "value2"
                $0.type = "string"
            },
            PBResource.with {
                $0.key = "key3"
                $0.value = "value3"
                $0.type = "string"
            },
        ]
    }
    
    static func simpleFlags() -> [PBFlag] {
        return [
            PBFlag.with {
                $0.name = "flag1"
                $0.values = [
                    PBValue.with {
                        $0.value = "value1"
                        $0.testID = 123
                    },
                    PBValue.with {
                        $0.value = "value11"
                        $0.testID = 1234
                        $0.condition = PBConditionList.with {
                            $0.values = [ ]
                        }
                    }
                ]
            },
            PBFlag.with {
                $0.name = "flag2"
                $0.values = [
                    PBValue.with {
                        $0.value = "value2"
                        $0.testID = 123
                    }
                ]
            },
        ]
    }
    
}
