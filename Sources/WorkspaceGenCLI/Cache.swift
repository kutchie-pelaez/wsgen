import Core
import CryptoKit
import Foundation
import PathKit
import Yams

private func cachePath(for name: String) -> Path {
    .home + ".wsgen" + "\(name)" + "cache.json"
}

final class Cache {
    init?(
        name: String?,
        configPath: Path
    ) {
        guard let name = name else { return nil }

        self.name = name
        self.configPath = configPath
    }

    private let name: String
    private let configPath: Path

    private lazy var manifest: Manifest? = {
        let decoder = YAMLDecoder()

        guard
            let manifestData = try? configPath.read(),
            let manifest: Manifest = try? decoder.decode(from: manifestData)
        else
        {
            return nil
        }

        return manifest
    }()

    func writeGenerationResultToCache(from manifest: Manifest) throws {
        let hash = try hash(from: manifest.workspaceElements)
        try cachePath(for: name).write(hash)
    }

    func shouldRegenerate(using newManifest: Manifest) -> Bool {
        guard let oldManifest = manifest else { return false }

        if oldManifest != newManifest {
            return true
        }

        guard
            let oldManifestHash = try? hash(from: oldManifest.workspaceElements),
            let newManifestHash = try? hash(from: newManifest.workspaceElements)
        else {
            return true
        }

        return oldManifestHash != newManifestHash
    }

    private func hash(from elements: [WorkspaceElement]) throws -> String {
        let reducedLocations = elements
            .map(\.location)
            .reduce("", +)

        guard let reducedLocationsData = reducedLocations.data(using: .utf8) else {
            throw CacheError.failedToGenerateCahce
        }

        let digest = Insecure.MD5.hash(data: reducedLocationsData)

        return digest
            .map {
                String(
                    format: "%02hhx",
                    $0
                )
            }
            .joined()

    }
}

enum CacheError: Error {
    case failedToGenerateCahce
}
