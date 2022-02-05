import Core
import CryptoKit
import Foundation
import PathKit
import Yams

public final class Cache {
    private static var cacheRootFolderPath: Path {
        .home + ".wsgen"
    }
    public static func cacheDomainFolderPath(for name: String) -> Path {
        cacheRootFolderPath + "\(name)"
    }
    public static func cachePath(for name: String) -> Path {
        cacheDomainFolderPath(for: name) + "cache"
    }

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

    private var cachedManifestHash: String? {
        let cachePath = Self.cachePath(for: name)

        guard
            let cacheData = try? cachePath.read(),
            let cacheString = String(data: cacheData, encoding: .utf8)
        else {
            return nil
        }

        return cacheString
    }

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

        if !Self.cacheRootFolderPath.exists {
            try Self.cacheRootFolderPath.mkdir()
        }

        if !Self.cacheDomainFolderPath(for: name).exists {
            try Self.cacheDomainFolderPath(for: name).mkdir()
        }

        try Self.cachePath(for: name).write(hash)
    }

    func shouldRegenerate(using newManifest: Manifest) -> Bool {
        guard let cachedManifestHash = cachedManifestHash else { return true }

        guard let newManifestHash = try? hash(from: newManifest.workspaceElements) else {
            return true
        }

        return cachedManifestHash != newManifestHash
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

// MARK: - CacheError

enum CacheError: Error {
    case failedToGenerateCahce
}
