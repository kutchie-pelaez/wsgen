extension Sorting {

    init(from types: [FileRef.FileRefType]) {
        var firstPart = [FileRef.FileRefType]()
        var secondPart = FileRef.FileRefType.allCases

        for type in types.unique {
            secondPart.removeAll { $0 == type }
            firstPart.append(type)
        }

        let result = firstPart + secondPart

        self = .init(
            first: result[0],
            second: result[1],
            third: result[2],
            fourth: result[3]
        )
    }

    static var `default`: Sorting {
        .init(from: FileRef.FileRefType.allCases)
    }
}

// MARK: - Array.unique

private extension Array where Element: Equatable {

    var unique: [Element] {
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
