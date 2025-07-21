import XCTest
@testable import VarioqubNetwork
import VarioqubUtils

final class USNetworkTaskRequestCreationTests: XCTestCase {

    let baseURL = URL(string: "https://example.org")!
    let mockExecutor = MockExecutor()
    let stubStorage = USTaskStorageStub()
    let threadChecker = ThreadChecker()

    let testData = "some data".data(using: .utf8)

    func testGET() {
        let request = Request(path: "path1",
                method: .GET,
                params: [:],
                body: nil,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1")!)
        urlRequest.httpMethod = "GET"

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

    func testGETWithParams() {
        let request = Request(path: "path1",
                method: .GET,
                params: [
                    "key1": "value1",
                    "key2": "value2"
                ],
                body: nil,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1?key1=value1&key2=value2")!)
        urlRequest.httpMethod = "GET"

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

    func testGETWithParamsOrdering() {
        let request = Request(path: "path1",
                method: .GET,
                params: [
                    "key1": "value1",
                    "key2": "value2"
                ],
                body: nil,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1?key2=value2&key1=value1")!)
        urlRequest.httpMethod = "GET"

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

    func testHEAD() {
        let request = Request(path: "path1",
                method: .HEAD,
                params: [:],
                body: nil,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1")!)
        urlRequest.httpMethod = "HEAD"

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

    func testHEADWithParams() {
        let request = Request(path: "path1",
                method: .HEAD,
                params: [
                    "key1": "value1",
                    "key2": "value2"
                ],
                body: nil,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1?key1=value1&key2=value2")!)
        urlRequest.httpMethod = "HEAD"

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

    func testPOSTEmptyBody() {
        let request = Request(path: "path1",
                method: .POST,
                params: [:],
                body: nil,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1")!)
        urlRequest.httpMethod = "POST"

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

    func testPOSTWithParams() {
        let request = Request(path: "path1",
                method: .POST,
                params: [
                    "key1": "value1",
                    "key2": "value2"
                ],
                body: nil,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1?key1=value1&key2=value2")!)
        urlRequest.httpMethod = "POST"

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

    func testPOSTWithData() {
        let request = Request(path: "path1",
                method: .POST,
                params: [
                    "key1": "value1",
                    "key2": "value2"
                ],
                body: testData,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1?key1=value1&key2=value2")!)
        urlRequest.httpMethod = "POST"
        urlRequest.httpBody = testData

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

    func testPATCHEmptyBody() {
        let request = Request(path: "path1",
                method: .PATCH,
                params: [:],
                body: nil,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1")!)
        urlRequest.httpMethod = "PATCH"

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

    func testPATCHWithParams() {
        let request = Request(path: "path1",
                method: .PATCH,
                params: [
                    "key1": "value1",
                    "key2": "value2"
                ],
                body: nil,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1?key1=value1&key2=value2")!)
        urlRequest.httpMethod = "PATCH"

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

    func testPATCHWithData() {
        let request = Request(path: "path1",
                method: .PATCH,
                params: [
                    "key1": "value1",
                    "key2": "value2"
                ],
                body: testData,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1?key1=value1&key2=value2")!)
        urlRequest.httpMethod = "PATCH"
        urlRequest.httpBody = testData

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

    func testPUTEmptyBody() {
        let request = Request(path: "path1",
                method: .PUT,
                params: [:],
                body: nil,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1")!)
        urlRequest.httpMethod = "PUT"

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

    func testPUTWithParams() {
        let request = Request(path: "path1",
                method: .PUT,
                params: [
                    "key1": "value1",
                    "key2": "value2"
                ],
                body: nil,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1?key1=value1&key2=value2")!)
        urlRequest.httpMethod = "PUT"

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

    func testPUTWithData() {
        let request = Request(path: "path1",
                method: .PUT,
                params: [
                    "key1": "value1",
                    "key2": "value2"
                ],
                body: testData,
                headers: .init()
        )
        var urlRequest = URLRequest(url: URL(string: "https://example.org/path1?key1=value1&key2=value2")!)
        urlRequest.httpMethod = "PUT"
        urlRequest.httpBody = testData

        compareConvert(request: request, expectedURLRequest: urlRequest)
    }

}

private extension USNetworkTaskRequestCreationTests {

    func compareConvert(request: Request, expectedURLRequest: URLRequest) {
        let dataTaskCreator = CatchURLRequestUSDataTaskCreatorMock()

        let taskTest = USNetworkTaskRequest(baseURL: baseURL,
                request: request,
                executor: mockExecutor,
                storage: stubStorage,
                dataTaskCreator: dataTaskCreator,
                threadChecker: threadChecker
        )

        taskTest.execute()

        XCTAssertTrue(URLRequest.assertURLRequestsEqual(dataTaskCreator.catchedURLRequest!, expectedURLRequest))
    }

}

extension URLRequest {

    static func assertURLRequestsEqual(_ r1: URLRequest, _ r2: URLRequest) -> Bool {
        if r1 == r2 {
            return true
        } else {
            var equals = URL.assertURLsEqual(r1.url!, r2.url!)
            equals = equals && (r1.httpMethod == r2.httpMethod)
            equals = equals && (r1.httpBody == r2.httpBody)
            equals = equals && (r1.httpBodyStream == r2.httpBodyStream)
            equals = equals && (r1.allHTTPHeaderFields == r2.allHTTPHeaderFields)
            return equals
        }
    }

}

extension URL {

    static func assertURLsEqual(_ u1: URL, _ u2: URL) -> Bool {
        // query may be different and rely on dictionary ordering
        if u1 == u2 {
            return true
        } else {
            let c1 = URLComponents(url: u1, resolvingAgainstBaseURL: true)!
            let c2 = URLComponents(url: u2, resolvingAgainstBaseURL: true)!

            var equals = true

            equals = equals && (c1.scheme == c2.scheme)
            equals = equals && (c1.host == c2.host)
            equals = equals && (c1.path == c2.path)
            equals = equals && (c1.port == c2.port)
            equals = equals && (c1.user == c2.user)
            equals = equals && (c1.password == c2.password)
            equals = equals && (c1.fragment == c2.fragment)

            if let q1 = c1.queryItems, let q2 = c2.queryItems {
                equals = equals && (Set(q1) == Set(q2))
            } else {
                equals = equals && (c1.queryItems == c2.queryItems)
            }

            return equals
        }
    }

}
