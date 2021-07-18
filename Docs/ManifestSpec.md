# Manifest Spec

- [Manifest Spec](#manifest-spec)
  - [General](#general)
  - [Example of full spec](#example-of-full-spec)
  - [Workspace](#workspace)
  - [SortingType](#sortingtype)
  - [Folder](#folder)

<br/>

## General

Manifest file can be written in YAML. Required properties are marked with checkbox. Manifest file should be named `workspace.yml`, if custom name is not specified. `package.yml` has structure of [**`Workspace`**](#Workspace) object at the top level.  

Here is an exapmle of project hierarchy before and after running `wsgen generate` command:

<details>
<summary>Before generation</summary>

```
root/
├── ...
└── workspace.yml
```

</details>

<details>
<summary>After generation</summary>

```
root/
├── ...
├── workspace.yml
└── <WorkspaceName>.xcworkspace/
    └── contents.xcworkspacedata
```
</details>

<br/>

## Example of full spec

<details>
<summary>Click to expand</summary>

```yaml
name: WorkspaceName

# All missing type sorting rules will be added
# automatically, hence full list after manifest
# parsing will be:
#
# sorting:
#   - NameOfItemAtVeryTop
#   - folder
#   - package
#   - project
#   - file
#
sorting:
  - NameOfItemAtVeryTop
  - folder
  - package

# Note that you should provide path to project
# without .xcodeproj extension here
#
projects:
  - SomeProject
  - Some/Path/To/Another/Project

# All folders are not recursive by default
# If you want to mark it as recursive you
# should set recursive: true to it
#
# Recursive folder will be replaced by array of
# its items
#
# For given hierarchy 
#
# root/
# ├── ...
# └── Folders/
#     ├── FolderA/...
#     ├── FolderB/...
#     ├── FolderC/...
#     └── FolderD/...
#
# you can decsribe folders value like this:
#
# folders:
#   - path: Folders
#     recursive: true
#
# same as:
#
# folders:
#   - Folders/FolderA
#   - Folders/FolderB
#   - Folders/FolderC
#   - Folders/FolderD
#
folders:
  - Folder
  - Another/Folder
  - path: Path/To/Recursive/Folder
    recursive: true

# Several files such as
# '.DS_Store'
# will be ignored here
# 
files:
  - text.txt
  - image.png
  - spec.md
```
</details>

<br/>

## Workspace

type: **object**

> - [x] **name**: **`String`** - Name of generated `.xcworkspace` directory
> - [ ] **sorting**: [**`[SortingType]`**](#SortingType) - List of rules for sorting items in workspace after generation. Can be configured from array of [**`SortingType`**](#SortingType) values + custom name of your items. Each group will be additionally sorted in ascending order.  
Default sorting will be used if not presented:
```yaml
sorting:
  - project
  - package
  - folder
  - file
```
> - [ ] **projects**: **`[String]`** - List of projects in workspace. Provide path to project without extensions relative to input path. You should specify `projects/SomeProject/SomeProject` in this case:
```
root/
├── ...
└── projects/
    └── SomeProject/
        ├── SomeProject/...
        └── SomeProject.xcodeproj
```
> - [ ] **folders**: [**`[Folder]`**](#Folder) - List of folders in workspace. Provide path relative to input path. Folder also can be recursive
> - [ ] **files**: **`[String]`** - List of files in workspace. Provide path relative to input path

<br/>

## SortingType

type: **enum** or **string**

> `'NameOfYourItem'`

*or*

> `project`  
> `package`  
> `folder`  
> `file`  

<br/>

## Folder

type: **object** or **string**

- If you provide folder with `recursive` flag, all child items of this folder will be added (only 1 level deep).

<br/>

> `'some/relative/path/to/folder'`

*or*

> - [x] **path**: **`String`**
> - [x] **recursive**: **`Bool`**
