// MARK: - CodingKeys

private enum CodingKeys: String, CodingKey {
    case fileRef = "FileRef"
}

// MARK: - Encodable

extension Manifest: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(workspaceElements, forKey: .fileRef)
    }
}
