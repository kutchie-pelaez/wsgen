public struct Manifest {

    public let name: String
    let sorting: Sorting
    let fileRefs: [FileRef]
}

// MARK: - Decodable

extension Manifest: Decodable {

    private enum CodingKeys: String, CodingKey {
        // YAML decoding
        case name
        case sorting
        case projects
        case flatFolders
        case folders
        case files

        // XML encoding
        case fileRef = "FileRef"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // name
        name = try container.decode(String.self, forKey: .name)

        // sorting
        if let sortingTypes = try? container.decode([Sorting.SortingType].self, forKey: .sorting) {
            sorting = .init(from: sortingTypes)
        } else {
            sorting = .default
        }

        // fileRefs
        var fileRefs = [FileRef]()
        self.fileRefs = fileRefs
    }
}

// MARK: - Encodable

extension Manifest: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(fileRefs, forKey: .fileRef)
    }
}
