// MARK: - CodingKeys

private enum CodingKeys: String, CodingKey {
    case fileRef = "FileRef"
}

// MARK: - Encodable

extension Manifest: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        for kind in WorkspaceElementKind.allCases {
            let workspaceElements = self.workspaceElements
                .filter { $0.kind == kind }

            try container.encode(workspaceElements, forKey: kind.codingKey)
        }
    }
}

private extension WorkspaceElementKind {

    var codingKey: CodingKeys {
        switch self {
        case .fileRef:
            return .fileRef
        }
    }
}
