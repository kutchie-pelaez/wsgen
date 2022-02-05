extension Folder: Decodable {
    private enum CodingKeys: String, CodingKey {
        case path
        case recursive
        case exclude
    }

    init(from decoder: Decoder) throws {
        let path: String
        let isRecursive: Bool
        let exclude: [String]

        if let singleValueContainer = try? decoder.singleValueContainer(),
           let singleValueContainerString = try? singleValueContainer.decode(String.self) {
            path = singleValueContainerString
            isRecursive = false
            exclude = []
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            path = try container.decode(String.self, forKey: .path)
            isRecursive = try container.decode(Bool.self, forKey: .recursive)
            exclude = (try? container.decode([String].self, forKey: .exclude)) ?? []
        }

        self = Folder(
            path: path,
            isRecursive: isRecursive,
            exclude: exclude
        )
    }
}
