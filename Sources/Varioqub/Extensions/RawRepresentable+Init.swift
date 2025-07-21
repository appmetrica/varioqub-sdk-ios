
extension RawRepresentable {

    init?(value: RawValue, hasValue: Bool) {
        if hasValue {
            self.init(rawValue: value)
        } else {
            return nil
        }
    }

}
