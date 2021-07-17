import PathKit

public var MANIFEST_OUTPUT_PATH: String = Path.current.string

public struct Manifest {

    public let name: String
    let fileRefs: [FileRef]
}

// MARK: - Decodable

extension Manifest: Decodable {

    private enum CodingKeys: String, CodingKey {
        // YAML decoding
        case name
        case sorting
        case projects
        case folders
        case files

        // XML encoding
        case fileRef = "FileRef"
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        // name
        name = try container.decode(String.self, forKey: .name)

        // sorting
        let sorting: Sorting
        if let sortingTypes = try? container.decode([FileRef.FileRefType].self, forKey: .sorting) {
            sorting = .init(from: sortingTypes)
        } else {
            sorting = .default
        }

        // fileRefs
        var fileRefs = [FileRef]()

        let decodedProjects = (try? container.decode([String].self, forKey: .projects)) ?? []
        let decodedFolders = (try? container.decode([Folder].self, forKey: .folders)) ?? []
        let decodedFiles = (try? container.decode([String].self, forKey: .files)) ?? []

        var projectsInFolders = [String]()
        var filesInFolders = [String]()

        var projects: [String] {
            decodedProjects + projectsInFolders
        }

        var folders: [Folder] {
            decodedFolders
        }

        let ignoringFilenames = [
            ".DS_Store"
        ]
        var files: [String] {
            (decodedFiles + filesInFolders)
                .filter { file in
                    ignoringFilenames
                        .map { !file.hasSuffix($0) }
                        .allSatisfy { $0 }
                }
        }

        foldersGeneratingBlock:
        do {
            var queue = Queue(folders)

            while let folder = queue.dequeue() {
                let location: String
                let type: FileRef.FileRefType

                if folder.isRecursive {
                    let children = (try? (Path(MANIFEST_OUTPUT_PATH) + folder.path).children()) ?? []

                    for child in children {
                        let childRelativePath = folder.path + "/" + child.lastComponent

                        if child.extension == "xcodeproj" {
                            projectsInFolders.append(folder.path + "/" + child.lastComponentWithoutExtension)
                        } else if child.isFile {
                            filesInFolders.append(childRelativePath)
                        } else if child.isDirectory {
                            queue.enqueue(
                                .init(
                                    path: childRelativePath,
                                    isRecursive: false
                                )
                            )
                        }
                    }

                    continue
                } else {
                    location = folder.path

                    let folderPackagePath: Path = Path(MANIFEST_OUTPUT_PATH) + folder.path + "Package.swift"
                    if folderPackagePath.exists {
                        type = .package
                    } else {
                        type = .folder
                    }
                }

                fileRefs.append(
                    .init(
                        location: location,
                        type: type
                    )
                )
            }
        }

        projectsGeneratingBlock:
        do {
            for project in projects {
                fileRefs.append(
                    .init(
                        location: project + ".xcodeproj",
                        type: .project
                    )
                )
            }
        }

        filesGeneratingBlock:
        do {
            for file in files {
                fileRefs.append(
                    .init(
                        location: file,
                        type: .file
                    )
                )
            }
        }

        fileRefsSortingBlock:
        do {
            fileRefs.sort { first, second in
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

        self.fileRefs = fileRefs
    }
}

// MARK: - Encodable

extension Manifest: Encodable {

    public func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)

        try container.encode(fileRefs, forKey: .fileRef)
    }
}

// Queue

private struct Queue<T> {

    init(_ array: [T] = []) {
        self.array = array
    }

    private var array: [T]

    mutating func enqueue(_ element: T) {
        array.insert(
            element,
            at: 0
        )
    }

    mutating func dequeue() -> T? {
        array.popLast()
    }
}
