import PathKit

public var MANIFEST_OUTPUT_PATH: String = Path.current.string

public struct Manifest {

    public let name: String
    let fileRefs: [FileRef]
}
