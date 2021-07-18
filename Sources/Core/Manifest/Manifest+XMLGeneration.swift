import XMLCoder
import Foundation

public extension Manifest {

    func generateXMLData() throws -> Data {
        let encoder = XMLEncoder()
        encoder.outputFormatting = .prettyPrinted

        let header = XMLHeader(
            version: 1.0,
            encoding: "UTF-8"
        )

        let data = try encoder.encode(
            self,
            withRootKey: "Workspace",
            rootAttributes: [
                "version": "1.0"
            ],
            header: header
        )

        return data
    }
}
