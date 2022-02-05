extension Sorting {
    static var `default`: Sorting {
        .init(from: WorkspaceElementType.allCases.map { $0.rawValue })
    }

    init(from strings: [String]) {
        var rules = strings
            .unique
            .map { string -> Rule in
                if let type = WorkspaceElementType(rawValue: string) {
                    return .byType(type)
                } else {
                    return .byName(string)
                }
            }

        for type in WorkspaceElementType.allCases {
            if !rules.contains(where: { $0.type == type }) {
                rules.append(.byType(type))
            }
        }

        self = .init(rules: rules)
    }

    func typeRuleIndex(for type: WorkspaceElementType) throws -> Int {
        guard let ruleIndex = rules.firstIndex(where: { $0.type == type }) else {
            throw SortingError.noTypeRuleFound(type: type.rawValue)
        }

        return ruleIndex
    }

    func nameRuleIndex(for name: String) -> Int? {
        rules.firstIndex { $0.name == name }
    }
}

// MARK: - Equatable

extension Sorting: Equatable {
    static func == (lhs: Sorting, rhs: Sorting) -> Bool {
        lhs.rules == rhs.rules
    }
}

// MARK: - SortingError

public enum SortingError: Error {
    case noTypeRuleFound(type: String)
}

// MARK: - Array.unique

extension Array where Element: Equatable {
    fileprivate var unique: [Element] {
        var result = [Element]()

        forEach { item in
            guard !result.contains(item) else {
                return
            }

            result.append(item)
        }

        return result
    }
}
