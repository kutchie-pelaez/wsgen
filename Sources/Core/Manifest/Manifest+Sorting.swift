extension Manifest {

    var sortedWorkspaceElements: [WorkspaceElement] {
        workspaceElements.sorted { first, second in
            let rules = [
                sorting.first,
                sorting.second,
                sorting.third,
                sorting.fourth
            ]

            if first.type == second.type {
                return first.name < second.name
            } else {
                let firstIndex = rules.firstIndex(of: first.type) ?? 0
                let secondIndex = rules.firstIndex(of: second.type) ?? 0

                return firstIndex < secondIndex
            }
        }
    }
}
