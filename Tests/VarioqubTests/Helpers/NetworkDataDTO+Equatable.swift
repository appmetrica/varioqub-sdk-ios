
@testable import Varioqub

extension NetworkDataDTO.Value: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.flag == rhs.flag &&
                lhs.testId == rhs.testId &&
                lhs.value == rhs.value
    }
}

extension NetworkDataDTO: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.flags == rhs.flags &&
                lhs.experimentId == rhs.experimentId &&
                lhs.id == rhs.id
    }

}
