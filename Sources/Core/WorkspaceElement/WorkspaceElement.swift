public struct WorkspaceElement: Equatable {

    public let location: String
    public let domain: Domain
    public let kind: WorkspaceElementKind
    public let type: WorkspaceElementType

    public var name: String {
        String(location.split(separator: "/").last ?? "")
    }
}

// MARK: - Domain

extension WorkspaceElement {

    public enum Domain: String {
        case group
    }
}

// MARK: - WorkspaceElementKind

public enum WorkspaceElementKind: CaseIterable {
    case fileRef
}

// MARK: - WorkspaceElementType

public enum WorkspaceElementType: String, Decodable, CaseIterable {
    case project
    case package
    case folder
    case file
}
