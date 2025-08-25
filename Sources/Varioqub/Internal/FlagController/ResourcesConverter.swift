
enum ResourcesConverter {
    
    static func convert(dto: ResourceDTO) -> VarioqubResource {
        return VarioqubResource(
            type: dto.type,
            value: dto.value
        )
    }
    
    static func convert(dtos: [ResourceDTO]) -> [VarioqubResourceKey: VarioqubResource] {
        let pairs = dtos.map { (VarioqubResourceKey(rawValue: $0.key), convert(dto: $0)) }
        return Dictionary(pairs, uniquingKeysWith: { $1 })
    }
    
}
