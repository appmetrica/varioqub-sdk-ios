
final class NullResourceProvider: VarioqubResourcesProvider {
    func resource(for key: VarioqubResourceKey) -> VarioqubResource? {
        return nil
    }
}
