@testable import Varioqub

extension VarioqubTransferValue: Equatable {
    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.testId == rhs.testId &&
                lhs.value == rhs.value
    }
}
