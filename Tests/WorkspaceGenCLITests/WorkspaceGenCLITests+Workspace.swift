import XMLCoder

extension WorkspaceGenCLITests {

    struct Workspace: Decodable, DynamicNodeDecoding {

        private enum CodingKeys: String, CodingKey {
            case fileRefs = "FileRef"
        }

        let fileRefs: [FileRef]

        static func nodeDecoding(for key: CodingKey) -> XMLDecoder.NodeDecoding {
            let decodingKey = key as! CodingKeys

            switch decodingKey {
            case .fileRefs:
                return .element
            }
        }
    }
}
