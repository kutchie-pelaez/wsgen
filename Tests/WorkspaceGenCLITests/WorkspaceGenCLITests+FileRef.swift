import XMLCoder

extension WorkspaceGenCLITests {
    struct FileRef: Decodable, DynamicNodeDecoding {
        private enum CodingKeys: String, CodingKey {
            case location
        }

        let location: String

        var name: String {
            let path = location
                .replacingOccurrences(
                    of: "group:",
                    with: ""
                )
                .replacingOccurrences(
                    of: ".xcodeproj",
                    with: ""
                )

            return String(path.split(separator: "/").last ?? "")
        }

        static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
            let decodingKey = key as! CodingKeys

            switch decodingKey {
            case .location:
                return .attribute
            }
        }
    }
}
