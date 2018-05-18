# react-native-cfstringtokenizer
Apple's CFStringTokenizer API bridged to React Native.

* TODO: make macOS build target suffixed with `-macOS.a`.
* TODO: rename from JBCFStringTokenizer -> RCTCFStringTokenizer.

# Installation

Add this module to your consumer project:

```
yarn add https://github.com/shirakaba/react-native-cfstringtokenizer.git#master
```

Add its `node_modules/react-native-cfstringtokenizer/apple/RCTCFStringTokenizer.xcodeproj` to your consumer project's `Build Phases ➜ Link Binary With Libraries` field.

For an Obj-C-only RN consumer project, you'll also add an empty `dummy.swift` to your source and accept when Xcode gives a prompt about generating a bridging header file for you.

In your consumer project, set `Build Settings > Always Embed Swift Standard Libraries` to YES, and clean the project and rebuild it.

In your consumer project, set `Build Settings > Swift Language Version` to `4.1` (matching that of this module), and clean the project and rebuild it.
