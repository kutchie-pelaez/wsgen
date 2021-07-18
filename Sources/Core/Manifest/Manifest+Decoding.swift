import PathKit

// MARK: - CodingKeys

private enum CodingKeys: String, CodingKey {
    case name
    case sorting
    case projects
    case folders
    case files
}

// MARK: - Decodable

extension Manifest: Decodable {

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)

        let sorting: Sorting
        if let sortingTypes = try? container.decode([WorkspaceElementType].self, forKey: .sorting) {
            sorting = .init(from: sortingTypes)
        } else {
            sorting = .default
        }

        let decodedFolders = (try? container.decode([Folder].self, forKey: .folders)) ?? []
        let decodedProjects = (try? container.decode([String].self, forKey: .projects)) ?? []
        let decodedFiles = (try? container.decode([String].self, forKey: .files)) ?? []

        let foldersProcessingResult = try Self.processFolders(
            decodedFolders
        )
        let projectsProcessingResult = Self.processProjects(
            decodedProjects + foldersProcessingResult.projectsNedeedToProcess
        )
        let filesProcessingResult = Self.processFiles(
            decodedFiles + foldersProcessingResult.filesNedeedToProcess
        )

        var workspaceElements = foldersProcessingResult.workspaceElements +
                                projectsProcessingResult.workspaceElements +
                                filesProcessingResult.workspaceElements

        Self.sortWorkspaceElements(
            &workspaceElements,
            using: sorting
        )

        self.workspaceElements = workspaceElements
    }
}

// MARK: - Folders

private extension Manifest {

    struct FoldersProcessingResult {
        var workspaceElements = [WorkspaceElement]()
        var projectsNedeedToProcess = [String]()
        var filesNedeedToProcess = [String]()
    }

    static func processFolders(_ folders: [Folder]) throws -> FoldersProcessingResult {
        guard let outputPathString = Self.outputPath else {
            throw ManifestDecodingError.manifestOutputPathIsNotSet
        }

        let outputPath = Path(outputPathString)
        var foldersQueue = folders
        var result = FoldersProcessingResult()

        while let folder = foldersQueue.popLast() {
            let location: String
            let type: WorkspaceElementType

            if folder.isRecursive {
                let children = (try? (outputPath + folder.path).children()) ?? []

                for child in children {
                    let childRelativePath = folder.path + "/" + child.lastComponent

                    if child.extension == "xcodeproj" {
                        result.projectsNedeedToProcess.append(folder.path + "/" + child.lastComponentWithoutExtension)
                    } else if child.isFile {
                        result.filesNedeedToProcess.append(childRelativePath)
                    } else if child.isDirectory {
                        foldersQueue.insert(
                            .init(
                                path: childRelativePath,
                                isRecursive: false
                            ),
                            at: 0
                        )
                    }
                }

                continue
            } else {
                location = folder.path

                let folderPackagePath: Path = outputPath + folder.path + "Package.swift"
                if folderPackagePath.exists {
                    type = .package
                } else {
                    type = .folder
                }
            }

            result.workspaceElements.append(
                .init(
                    location: location,
                    domain: .group,
                    kind: .fileRef,
                    type: type
                )
            )
        }

        return result
    }
}

// MARK: - Projects

private extension Manifest {

    struct ProjectsProcessingResult {
        var workspaceElements = [WorkspaceElement]()
    }

    static func processProjects(_ projects: [String]) -> ProjectsProcessingResult {
        var result = ProjectsProcessingResult()

        for project in projects {
            result.workspaceElements.append(
                .init(
                    location: project + ".xcodeproj",
                    domain: .group,
                    kind: .fileRef,
                    type: .project
                )
            )
        }

        return result
    }
}

// MARK: - Files

private extension Manifest {

    struct FilesProcessingResult {
        var workspaceElements = [WorkspaceElement]()
    }

    static let ignoringFilenames = [
        ".DS_Store"
    ]

    static func processFiles(_ files: [String]) -> FilesProcessingResult {
        var result = FilesProcessingResult()
        let files = files
            .filter { file in
                ignoringFilenames
                    .map { !file.hasSuffix($0) }
                    .allSatisfy { $0 }
            }

        for file in files {
            result.workspaceElements.append(
                .init(
                    location: file,
                    domain: .group,
                    kind: .fileRef,
                    type: .file
                )
            )
        }

        return result
    }
}

// MARK: - Sorting

private extension Manifest {

    static func sortWorkspaceElements(_ workspaceElements: inout [WorkspaceElement], using sorting: Sorting) {
        workspaceElements.sort { first, second in
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

// MARK: - ManifestDecodingError

public extension Manifest {

    enum ManifestDecodingError: Error {
        case manifestOutputPathIsNotSet
    }
}
