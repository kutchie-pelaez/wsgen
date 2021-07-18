enum WorkspaceElementType {
    case project
    case package
    case folder
    case file
    case custom(String)
}

// MARK: - RawRepresentable

extension WorkspaceElementType: RawRepresentable {

    typealias RawValue = String

    init?(rawValue: String) {
        switch rawValue {
        case "project":
            self = .project

        case "package":
            self = .package

        case "folder":
            self = .folder

        case "file":
            self = .file

        default:
            self = .custom(rawValue)
        }
    }

    var rawValue: RawValue {
        switch self {
        case .project:
            return "project"

        case .package:
            return "package"

        case .folder:
            return "folder"

        case .file:
            return "file"

        case let .custom(value):
            return value
        }
    }
}

// MARK: - Equatable

extension WorkspaceElementType: Equatable {

    static func == (lhs: Self, rhs: Self) -> Bool {
        lhs.rawValue == rhs.rawValue
    }

}

// MARK: - Decodable

extension WorkspaceElementType: Decodable {

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()

        let value = try container.decode(String.self)

        guard let workspaceElementType = WorkspaceElementType(rawValue: value) else {
            throw WorkspaceElementTypeDecodingError.invalidValue
        }

        self = workspaceElementType
    }
}

// MARK: - CaseIterable

extension WorkspaceElementType: CaseIterable {

    static var allCases: [WorkspaceElementType] {
        [
            .project,
            .package,
            .folder,
            .file
        ]
    }
}

// MARK: - WorkspaceElementTypeDecodingError

public enum WorkspaceElementTypeDecodingError: Error {
    case invalidValue
}
