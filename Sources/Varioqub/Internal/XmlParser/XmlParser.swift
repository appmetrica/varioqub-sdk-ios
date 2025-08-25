import Foundation

enum XmlParserError: Error {
    case openFile
    case xmlStructure
    case underlying(error: Error)
}

final class XmlParser: NSObject {

    private var defaults: [VarioqubFlag: VarioqubValue] = [:]
    private var isParsed = false
    private var parseError: XmlParserError?
    private var state: State = .global

    private var currentKey: String?
    private var currentValue: String?

    private let source: XmlParserSource

    init(url: URL) {
        self.source = .file(url)
    }

    init(data: Data) {
        self.source = .data(data)
    }

    func parse() throws -> [VarioqubFlag: VarioqubValue] {
        if isParsed {
            return defaults
        } else {
            try doParse()
            if let parseError = parseError {
                throw parseError
            }
            return defaults
        }
    }

}

extension XmlParser: XMLParserDelegate {

    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        self.parseError = .underlying(error: parseError)
    }

    func parser(_ parser: XMLParser, validationErrorOccurred validationError: Error) {
        self.parseError = .underlying(error: validationError)
    }

    func parser(_ parser: XMLParser,
                didStartElement elementName: String,
                namespaceURI: String?,
                qualifiedName qName: String?,
                attributes attributeDict: [String: String]) {
        handleXmlParserDelegate(for: elementName) { transition in

            switch state {
            case .global:
                transition.moveIf(tagName: "defaults", to: .defaults)
            case .defaults:
                transition.moveIf(tagName: "entry", to: .entry)
                currentValue = nil
                currentKey = nil
            case .entry:
                transition.moveIf(tagName: "key", to: .key)
                transition.moveIf(tagName: "value", to: .value)
            case .value, .key:
                break
            }

        }
    }


    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        handleXmlParserDelegate(for: elementName) { transition in
            switch state {
            case .global:
                break
            case .defaults:
                transition.moveIf(tagName: "defaults", to: .global)
            case .entry:
                transition.moveIf(tagName: "entry", to: .defaults)
                if let currentValue = currentValue, let currentKey = currentKey {
                    defaults[.init(rawValue: currentKey)] = .init(string: currentValue)
                } else {
                    throw XmlParserError.xmlStructure
                }
            case .key:
                transition.moveIf(tagName: "key", to: .entry)
            case .value:
                transition.moveIf(tagName: "value", to: .entry)
            }
        }
    }

    func parser(_ parser: XMLParser, foundCharacters string: String) {
        guard parseError == nil else {
            return
        }

        switch state {
        case .key:
            currentKey = (currentKey ?? "") + string
        case .value:
            currentValue = (currentValue ?? "") + string
        default:
            break
        }
    }

}

private extension XmlParser {

    func doParse() throws {
        defaults = [:]
        parseError = nil

        let parser = try makeParser()
        parser.delegate = self

        parser.parse()
    }

    func makeParser() throws -> XMLParser {
        switch source {
        case .file(let url):
            if let parser = XMLParser(contentsOf: url) {
                return parser
            } else {
                throw XmlParserError.openFile
            }
        case .data(let data):
            return XMLParser(data: data)
        }
    }

    func handleXmlParserDelegate(for elementName: String, _ closure: (inout Transition) throws -> ()) {
        guard parseError == nil else {
            return
        }

        do {
            var transition = Transition(elementName: elementName)
            try closure(&transition)

            state = try transition.getState()
        } catch let e as XmlParserError {
            varioqubLogger.error("parsing error: \(e)")
            parseError = e
        } catch let e {
            varioqubLogger.error("parsing error: \(e)")
            parseError = .underlying(error: e)
        }
    }


}

private enum XmlParserSource {
    case file(URL)
    case data(Data)
}

private enum State {
    case global
    case defaults
    case entry
    case key
    case value
}

private struct Transition {
    let elementName: String

    init(elementName: String) {
        self.elementName = elementName
    }

    var newState: State?

    mutating func moveIf(tagName: String, to newState: State) {
        if tagName == elementName {
            self.newState = newState
        }
    }

    func getState() throws -> State {
        if let newState = newState {
            return newState
        } else {
            throw XmlParserError.xmlStructure
        }
    }
}
