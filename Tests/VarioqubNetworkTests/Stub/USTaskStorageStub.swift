import Foundation
@testable import VarioqubNetwork

final class USTaskStorageStub: USNetworkTaskStoragable {
    func insert(networkTask: USNetworkTaskRequest, for sessionTask: URLSessionTask) {}

    func remove(task: URLSessionTask) {}
}
