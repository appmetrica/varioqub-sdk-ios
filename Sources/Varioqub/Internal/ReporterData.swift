
struct ReporterData {
    var testIds: VarioqubTestIDSet = .init()
    var experiment: String = ""

    mutating func appendTestId(_ testId: VarioqubTestID) {
        testIds.append(testId)
    }
}

struct ReporterDataDTO: Codable {
    var testIds: [Int64]
    var experiment: String
}

extension ReporterDataDTO {

    var value: ReporterData {
        ReporterData(testIds: .init(seq: testIds.map { VarioqubTestID(rawValue: $0) }), experiment: experiment)
    }

}

extension ReporterData {

    var dto: ReporterDataDTO {
        .init(testIds: testIds.set.map(\.rawValue), experiment: experiment)
    }

}
