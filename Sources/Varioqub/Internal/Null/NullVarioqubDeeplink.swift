
import Foundation

final class NullVarioqubDeeplink: VarioqubDeeplinkInput {
    func handleDeeplink(_ url: URL) -> Bool {
        return false
    }
}
