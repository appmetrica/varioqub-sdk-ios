protocol VarioqubInitializable: AnyObject {
    func start()
}

protocol VariqubLoadable {
    func load()
}

final class VarioqubInitializer: VarioqubInitializable {

    let items: [VariqubLoadable]

    init(items: [VariqubLoadable]) {
        self.items = items
    }

    func start() {
        items.forEach { $0.load() }
    }

}
