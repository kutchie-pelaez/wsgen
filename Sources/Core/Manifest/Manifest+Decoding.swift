import PathKit

extension Manifest: Decodable {
    private enum CodingKeys: String, CodingKey {
        case name
        case sorting
        case projects
        case folders
        case files
    }

    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)

        name = try container.decode(String.self, forKey: .name)

        let sorting: Sorting
        if let sortingRules = try? container.decode([String].self, forKey: .sorting) {
            sorting = Sorting(from: sortingRules)
        } else {
            sorting = .default
        }
        self.sorting = sorting

        let decodedFolders = (try? container.decode([Folder].self, forKey: .folders)) ?? []
        let decodedProjects = (try? container.decode([String].self, forKey: .projects)) ?? []
        let decodedFiles = (try? container.decode([String].self, forKey: .files)) ?? []

        let foldersProcessingResult = try Self.processFolders(
            decodedFolders
        )
        let projectsProcessingResult = Self.processProjects(
            decodedProjects + foldersProcessingResult.projectsToProcess
        )
        let filesProcessingResult = Self.processFiles(
            decodedFiles + foldersProcessingResult.filesToProcess
        )

        self.workspaceElements =
            foldersProcessingResult.workspaceElements +
            projectsProcessingResult.workspaceElements +
            filesProcessingResult.workspaceElements
    }
}

// MARK: - Folders

extension Manifest {
    fileprivate struct FoldersProcessingResult {
        var workspaceElements = [WorkspaceElement]()
        var projectsToProcess = [String]()
        var filesToProcess = [String]()
    }

    fileprivate static func processFolders(_ folders: [Folder]) throws -> FoldersProcessingResult {
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

                recursiveFolderLoop: for child in children {
                    let childRelativePath = folder.path + "/" + child.lastComponent

                    guard !folder.exclude.contains(child.lastComponentWithoutExtension) else {
                        continue recursiveFolderLoop
                    }

                    if child.extension == "xcodeproj" {
                        result.projectsToProcess.append(folder.path + "/" + child.lastComponentWithoutExtension)
                    } else if child.isFile {
                        result.filesToProcess.append(childRelativePath)
                    } else if child.isDirectory {
                        foldersQueue.insert(
                            Folder(
                                path: childRelativePath,
                                isRecursive: false,
                                exclude: []
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
                WorkspaceElement(
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

extension Manifest {
    fileprivate struct ProjectsProcessingResult {
        var workspaceElements = [WorkspaceElement]()
    }

    fileprivate static func processProjects(_ projects: [String]) -> ProjectsProcessingResult {
        var result = ProjectsProcessingResult()

        for project in projects {
            result.workspaceElements.append(
                WorkspaceElement(
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

extension Manifest {
    fileprivate struct FilesProcessingResult {
        var workspaceElements = [WorkspaceElement]()
    }

    fileprivate  static let ignoringFilenames = [
        ".DS_Store"
    ]

    fileprivate static func processFiles(_ files: [String]) -> FilesProcessingResult {
        var result = FilesProcessingResult()
        let files = files
            .filter { file in
                ignoringFilenames
                    .map { !file.hasSuffix($0) }
                    .allSatisfy { $0 }
            }

        for file in files {
            result.workspaceElements.append(
                WorkspaceElement(
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

// MARK: - ManifestDecodingError

extension Manifest {
    public enum ManifestDecodingError: Error {
        case manifestOutputPathIsNotSet
    }
}
