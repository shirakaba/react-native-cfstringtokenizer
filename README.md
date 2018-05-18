# react-native-cfstringtokenizer

Apple's CFStringTokenizer API bridged to React Native.

* TODO: make macOS build target suffixed with `-macOS.a`.
* TODO: rename from JBCFStringTokenizer -> RCTCFStringTokenizer.

# Installation

Add this module to your consumer project:

```
yarn add https://github.com/shirakaba/react-native-cfstringtokenizer.git#master
```

<!-- * Add its `node_modules/react-native-cfstringtokenizer/apple/RCTCFStringTokenizer.xcodeproj` to your consumer project's `Build Phases ➜ Link Binary With Libraries` field. -->

<!-- For an Obj-C-only RN consumer project, you'll also add an empty `dummy.swift` to your source and accept when Xcode gives a prompt about generating a bridging header file for you. -->

* In your consumer project, set `Build Settings > Always Embed Swift Standard Libraries` to YES, and clean the project and rebuild it.

* In your consumer project, set `Build Settings > Swift Language Version` to `4.1` (matching that of this module), and clean the project and rebuild it.

Following [zxcpoiu's instructions](https://gist.github.com/robertjpayne/855fdb15d5ceca12f6c5#gistcomment-1747749):

* Add the `node_modules/react-native-cfstringtokenizer/apple/RCTCFStringTokenizer` folder to your consumer project's `Libraries` folder. *I left `Copy items if needed` unchecked and selected `Added folders: Create folder references`.*

* Specify your bridging header location (I used the bundled bridging header):

```
../node_modules/react-native-cfstringtokenizer/apple/RCTCFStringTokenizer/RCTCFStringTokenizer-Bridging-Header.h
```

* You may prefer to make a standalone bridging header instead; this may be necessary for handling other Swift submodules in your consumer Xcode project. This could probably be done by adding an empty `dummy.swift` to your source and accepting when Xcode gives a prompt about generating a bridging header file for you. In such case, it should be importing some/all of the same React Native headers that this submodule is providing.

# Usage

Import into JS via:

```
import CFStringTokenizer from 'react-native-cfstringtokenizer';
// It's a default export, so we can name it whatever we want.

// API to be determined
```
