
final class NullVarioqubConfigurable: VarioqubConfigurable {
    func fetchConfig(_ callback: FetchCallback?) {
        callback?(.success)
    }
    
    func activateConfig(_ callback: ActivateCallback?) {
        callback?()
    }
    
    func activateConfigAndWait() {
        
    }
    
    func fetchAndActivateConfig(_ callback: FetchCallback?) {
        
    }
    
}
