# WorkspaceGen [![license](https://img.shields.io/badge/license-MIT-lightgrey.svg)](https://github.com/kulikov-ivan/wsgen/master/LICENSE) [![release](https://img.shields.io/github/release/kulikov-ivan/wsgen.svg)](https://github.com/kulikov-ivan/wsgen/releases)

WorkspaceGen is command line tool that generates `<WorkspaceName>.xcworkspace/contents.xcworkspacedata` file based on `workspace.yml` manifest file.  

This tool allows you to describe whole contents of your Xcode workspace by providing small `workspace.yml` configuration file.  

<br />

## Installing

### From release (recommended)

```shell
git clone https://github.com/kulikov-ivan/wsgen wsgen
cd wsgen
git checkout release/1.0.0
swift build
cp .build/debug/wsgen /your/path/to/wsgen/somewhere/in/your/project
```

### Homebrew (not supported yet)

```shell
brew install wsgen
```

### Swift Package Manager

```swift
.package(url: "https://github.com/kulikov-ivan/wsgen.git", from: "1.0.0")
```

<br />

## Usage

All you need to do is:
- Create `workspace.yml` somewhere in project (root of project would be good choise)
- Fill `workspace.yml` with all field you need (see [Manifest Spec](https://github.com/kulikov-ivan/wsgen/blob/master/Docs/ManifestSpec.md) for more info)
- **[Recommended]** copy compiled version of `wsgen` to your local project
- Run following command to generate `<WorkspaceName>.xcworkspacedata.xcworkspace/contents` file
```shell
wsgen generate
``` 

- **[Optional]** add `<WorkspaceName>.xcworkspace/` to your `.gitignore` to keep things clear 🙂

<br />

## Available Commands

```shell
wsgen generate [input_path] [output_path] [options]
```

This command will look for manifest file at provided `input_path` and generate `<WorkspaceName>.xcworkspace` folder at `output_path/<WorkspaceName>.xcworkspace` and `output_path/<WorkspaceName>.xcworkspace/contents.xcworkspacedata` file.

Arguments:

- **input_path** - Path to manifest file. Default is `./workspace.yml`.
- **output_path** - Path to root folder of generated `<WorkspaceName>.xcworkspace` folder. Default is `.`.

Options:

- **-q --quietly** - Disable all logs

```shell
wsgen help
```

Get detailed usage information from cli.

<br />

## Documentation

- See [Manifest Spec](https://github.com/kulikov-ivan/wsgen/blob/master/Docs/ManifestSpec.md) for available properties for workspace.yml manifest files

<br />

## Attributions

This tool is powered by:

- [Yams](https://github.com/jpsim/Yams)
- [XMLCoder](https://github.com/MaxDesiatov/XMLCoder)
- [SwiftCLI](https://github.com/jakeheis/SwiftCLI)
- [Rainbow](https://github.com/onevcat/Rainbow)
- [PathKit](https://github.com/kylef/PathKit)

Inspiration for this tool came from:

- [XcodeGen](https://github.com/yonaskolb/XcodeGen)
- [Weaver](https://github.com/scribd/Weaver)

<br />

## Contributing
Feel free to make pull requests for any bugs, features, or documentation, they are always welcome!  
To contribute to wsgen, follow these steps:  

1. Fork this repository
2. Create a branch: `git checkout -b <branch_name>`
3. Make your changes and commit them: `git commit -m '<commit_message>'`
4. Push to the original branch: `git push origin dev`
5. Create the pull request

<br />

## License

MIT license. See [LICENSE](LICENSE) for details.
