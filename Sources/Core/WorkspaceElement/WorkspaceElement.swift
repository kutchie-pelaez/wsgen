public struct WorkspaceElement: Equatable {
    public let location: String
    let domain: Domain
    let kind: WorkspaceElementKind
    let type: WorkspaceElementType

    var name: String {
        String(location.split(separator: "/").last ?? "")
    }
}

// MARK: - Domain

extension WorkspaceElement {
    enum Domain: String {
        case group
    }
}

// MARK: - WorkspaceElementKind

enum WorkspaceElementKind: CaseIterable {
    case fileRef
}

// MARK: - WorkspaceElementType

enum WorkspaceElementType: String, Decodable, CaseIterable {
    case project
    case package
    case folder
    case file
}
