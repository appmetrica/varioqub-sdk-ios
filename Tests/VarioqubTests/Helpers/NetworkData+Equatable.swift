
@testable import Varioqub

extension NetworkData: Equatable {

    public static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.flags == rhs.flags &&
        lhs.id == rhs.id &&
        lhs.experimentId == rhs.experimentId &&
        lhs.fetchDate == rhs.fetchDate
    }

}
