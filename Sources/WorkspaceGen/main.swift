import WorkspaceGenCLI
import Foundation

let cli = WorkspaceGenCLI()
let status = cli.execute()

exit(status)
