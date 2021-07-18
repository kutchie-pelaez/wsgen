struct WorkspaceElement {

    let location: String
    let type: WorkspaceElementType
    let domain: Domain

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

// MARK: - WorkspaceElementType

enum WorkspaceElementType: String, Decodable, CaseIterable {
    case project
    case package
    case folder
    case file
}
