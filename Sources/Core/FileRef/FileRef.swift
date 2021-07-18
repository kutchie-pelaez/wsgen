struct FileRef {

    let location: String
    let type: FileRefType
    let domain: Domain

    var name: String {
        String(location.split(separator: "/").last ?? "")
    }
}

// MARK: - FileRefType

extension FileRef {

    enum FileRefType: String, Decodable, CaseIterable {
        case project
        case package
        case folder
        case file
    }
}

// MARK: - Domain

extension FileRef {

    enum Domain: String {
        case group
    }
}
