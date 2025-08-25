
struct ReporterDataDTO: Equatable {
    var testIds: VarioqubTestIDSet = .init()
    var experiment: String = ""

    mutating func appendTestId(_ testId: VarioqubTestID) {
        testIds.append(testId)
    }
}

struct ReporterDataDSO: Equatable, Codable {
    var testIds: Set<Int64>
    var experiment: String
}

extension ReporterDataDSO {

    var value: ReporterDataDTO {
        ReporterDataDTO(testIds: .init(seq: testIds.map { VarioqubTestID(rawValue: $0) }), experiment: experiment)
    }

}

extension ReporterDataDTO {

    var dto: ReporterDataDSO {
        .init(testIds: Set(testIds.set.map(\.rawValue)), experiment: experiment)
    }

}
