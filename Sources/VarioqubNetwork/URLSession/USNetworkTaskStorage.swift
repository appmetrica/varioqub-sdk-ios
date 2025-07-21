import Foundation
#if VQ_MODULES
import VarioqubUtils
#endif

// sourcery: AutoMockable
protocol USNetworkTaskStoragable: AnyObject {
    func insert(networkTask: USNetworkTaskRequest, for sessionTask: URLSessionTask)
    func remove(task: URLSessionTask)
}

final class USNetworkTaskStorage {

    private let taskLock = UnfairLock()
    private var taskMapping: [URLSessionTask: USNetworkTaskRequest] = [:]

    func getRequest(for task: URLSessionTask) -> USNetworkTaskRequest? {
        taskLock.lock {
            taskMapping[task]
        }
    }

}

extension USNetworkTaskStorage: USNetworkTaskStoragable {

    func insert(networkTask: USNetworkTaskRequest, for sessionTask: URLSessionTask) {
        taskLock.lock {
            taskMapping[sessionTask] = networkTask
        }
    }

    func remove(task: URLSessionTask) {
        taskLock.lock {
            _ = taskMapping.removeValue(forKey: task)
        }
    }

}
