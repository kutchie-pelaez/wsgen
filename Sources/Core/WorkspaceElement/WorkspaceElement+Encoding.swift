import XMLCoder

// MARK: - CodingKeys

private enum CodingKeys: String, CodingKey {
    case location
}

// MARK: - Encodable

extension WorkspaceElement: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode("\(domain.rawValue):\(location)", forKey: .location)
    }
}

// MARK: - DynamicNodeEncoding

extension WorkspaceElement: DynamicNodeEncoding {

    public static func nodeEncoding(for key: CodingKey) -> XMLEncoder.NodeEncoding {
        let key = key as! CodingKeys

        switch key {
        case .location:
            return .attribute
        }
    }
}
