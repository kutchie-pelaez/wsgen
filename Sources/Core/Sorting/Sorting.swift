struct Sorting {

    let rules: [Rule]

    init(rules: [Rule]) {
        self.rules = rules
    }
}

// MARK: - Rule

extension Sorting {

    enum Rule: Equatable {
        case byType(WorkspaceElementType)
        case byName(String)

        var type: WorkspaceElementType? {
            if case let .byType(type) = self {
                return type
            }

            return nil
        }

        var name: String? {
            if case let .byName(name) = self {
                return name
            }

            return nil
        }
    }
}
