// MARK: - Sorting

extension Manifest {

    struct Sorting {
        let first: SortingType
        let second: SortingType
        let third: SortingType
        let fourth: SortingType

        init(from sortingTypes: [SortingType]) {
            first = .projects
            second = .packages
            third = .folders
            fourth = .files
        }

        static var `default`: Sorting {
            .init(
                from: [
                    .projects,
                    .packages,
                    .folders,
                    .files
                ]
            )
        }
    }
}

// MARK: - SortingType

extension Manifest.Sorting {

    enum SortingType: String, Decodable {
        case projects
        case packages
        case folders
        case files
    }
}
