struct FileRef {

    let location: String
    let type: FileRefType

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
