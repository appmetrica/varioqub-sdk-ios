
// similar to RawRepresentable+Protobuf, but avoid RawRepresentable to hide internal structure


extension VarioqubValue {

    init?(value: String, hasValue: Bool) {
        if hasValue {
            self.init(string: value)
        } else {
            return nil
        }
    }

}
