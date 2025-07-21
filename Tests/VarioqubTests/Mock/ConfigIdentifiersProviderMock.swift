
@testable import Varioqub

final class ConfigIdentifiersProviderMock: VarioqubIdentifiersProvider {
    var varioqubIdentifier: String?

    init(id: String?) { self.varioqubIdentifier = id }
}
