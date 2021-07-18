import XMLCoder

// MARK: - CodingKeys

private enum CodingKeys: String, CodingKey {
    case location
}

// MARK: - Encodable

extension FileRef: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        let encodingLocation = "group:\(location)"
        try container.encode(encodingLocation, forKey: .location)
    }
}

// MARK: - DynamicNodeEncoding

extension FileRef: DynamicNodeEncoding {

    static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        let key = key as! CodingKeys

        switch key {
        case .location:
            return .attribute
        }
    }
}
