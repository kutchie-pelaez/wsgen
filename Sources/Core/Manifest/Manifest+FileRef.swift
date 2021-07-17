import XMLCoder

// MARK: - FileRef

extension Manifest {

    struct FileRef {

        let location: String
        let type: FileRefType

        var name: String {
            String(location.split(separator: "/").last ?? "")
        }
    }
}

// MARK: - FileRefType

extension Manifest.FileRef {

    enum FileRefType: String, Decodable, CaseIterable {
        case project
        case package
        case folder
        case file
    }
}

// MARK: - Encodable

extension Manifest.FileRef: Encodable {

    private enum CodingKeys: String, CodingKey {
        case location
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        let groupLocation = "group:\(location)"
        try container.encode(groupLocation, forKey: .location)
    }
}

// MARK: - DynamicNodeEncoding

extension Manifest.FileRef: DynamicNodeEncoding {

    static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        let key = key as! CodingKeys

        switch key {
        case .location:
            return .attribute
        }
    }
}
