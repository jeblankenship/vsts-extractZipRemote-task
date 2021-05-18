# Remove Duplicate File(s) Task
Build task for VS Team Services that extracts zip file on remote computer to a folder a that computer..


02/17/2017: Added retry loop, due to file system not always letting go of files fast enough when removing the previous contents of the destination folder

08/30/2016: This task is not ready for general public use yet.

### Install tools

```
npm install -g tfx-cli
```
*restore VSCode to get tfx to work*

# Setup Typescript
```
tsc --init
```

# Build
```
tfx extension create --manifest-globs vss-extension.json
```

Updated my notes based on: https://www.andrewhoefling.com/Blog/Post/dev-ops-vsts-custom-build-task-extension
