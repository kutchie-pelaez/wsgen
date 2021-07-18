// MARK: - CodingKeys

private enum CodingKeys: String, CodingKey {
    case path
    case recursive
}

// MARK: - Decodable

extension Folder: Decodable {

    init(from decoder: Decoder) throws {
        let path: String
        let isRecursive: Bool

        if let singleValueContainer = try? decoder.singleValueContainer(),
           let singleValueContainerString = try? singleValueContainer.decode(String.self) {
            path = singleValueContainerString
            isRecursive = false
        } else {
            let container = try decoder.container(keyedBy: CodingKeys.self)

            path = try container.decode(String.self, forKey: .path)
            isRecursive = try container.decode(Bool.self, forKey: .recursive)
        }

        self = .init(
            path: path,
            isRecursive: isRecursive
        )
    }
}
