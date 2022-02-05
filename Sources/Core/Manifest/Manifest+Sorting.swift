extension Manifest {
    var sortedWorkspaceElements: [WorkspaceElement] {
        get throws {
            try workspaceElements.sorted { first, second in
                let firstTypeRuleIndex = try sorting.typeRuleIndex(for: first.type)
                let secondTypeRuleIndex = try sorting.typeRuleIndex(for: second.type)

                let firstNameRuleIndex = sorting.nameRuleIndex(for: first.name)
                let secondNameRuleIndex = sorting.nameRuleIndex(for: second.name)

                if
                    let firstNameRuleIndex = firstNameRuleIndex,
                    let secondNameRuleIndex = secondNameRuleIndex
                {
                    return firstNameRuleIndex < secondNameRuleIndex
                } else if let firstNameRuleIndex = firstNameRuleIndex {
                    return firstNameRuleIndex < secondTypeRuleIndex
                } else if let secondNameRuleIndex = secondNameRuleIndex {
                    return firstTypeRuleIndex < secondNameRuleIndex
                } else if firstTypeRuleIndex == secondTypeRuleIndex {
                    return first.name < second.name
                }

                return firstTypeRuleIndex < secondTypeRuleIndex
            }
        }
    }
}

// case project
// case package
// case folder
// case file
