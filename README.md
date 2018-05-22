# react-native-cfstringtokenizer

Apple's CFStringTokenizer API bridged to React Native.


# Installation

Add this module to your consumer project:

```
yarn add https://github.com/shirakaba/react-native-cfstringtokenizer.git#master
```

<!-- * Add its `node_modules/react-native-cfstringtokenizer/apple/RCTCFStringTokenizer.xcodeproj` to your consumer project's `Build Phases ➜ Link Binary With Libraries` field. -->

<!-- For an Obj-C-only RN consumer project, you'll also add an empty `dummy.swift` to your source and accept when Xcode gives a prompt about generating a bridging header file for you. -->

* In your consumer project, set `Build Settings > Always Embed Swift Standard Libraries` to YES.

* In your consumer project, set `Build Settings > Swift Language Version` to `4.1` (matching that of this module), and clean the project and rebuild it.

Following [zxcpoiu's instructions](https://gist.github.com/robertjpayne/855fdb15d5ceca12f6c5#gistcomment-1747749):

* Add the `node_modules/react-native-cfstringtokenizer/apple/RCTCFStringTokenizer` folder to your consumer project's `Libraries` folder. *I left `Copy items if needed` unchecked and selected `Added folders: Create groups`.*

* Make a bridging header* for your project, if you don't already have one. For a consumer project called `MyConsumerProject`, for example, you could name it `MyConsumerProject-Bridging-Header.h` and place it in the same folder as `MyConsumerProject.xcodeproj` so that it is easier to specify the path for the next step...

* In the above-mentioned MyConsumerProject project menu, select a build target (e.g. iOS or tvOS), then go into `Build Settings > Objective-C Bridging Header` and set it to `MyConsumerProject-Bridging-Header.h`. Don't worry about getting the path right first time; if it is wrong, you'll get an explicit error about it at build time, and you can adjust it.

* If you get an error such as `dyld: Library not loaded: @rpath/libswift_stdlib_core.dylib`, then you may need to add `@executable_path/../Frameworks/` to your runtime searchpaths. I think this is because the module is nested in `node_modules`.

*\* So far, I've only needed to specify `#import <React/RCTBridgeModule.h>` in my bridging header; no other imports are needed to support this module. And even then, that import only became necessary as a result of introducing Promises.*

# Usage

Import into JS via:

```
import {NativeModules} from 'react-native';

const msg: string = "Hello, my name is Steve Jobs";
NativeModules.RNCFStringTokenizer.copyBestStringLanguage(msg, msg.length)
.then((bestStringLanguage: string) => {
    console.log(`Got bestStringLanguage from Swift:`, bestStringLanguage);
})
.catch((e) => console.error(e));

NativeModules.RNCFStringTokenizer.transliterate("週休七日で働きたい", "ja")
.then((transliterations: string) => {
    console.log(`Got transliterations from Swift:`, transliterations);
})
.catch((e) => console.error(e));
```

Note that you can also shorten the namespacing for convenience (if you wish) by exploiting the default export from this npm module:

```
import CFStringTokenizer from 'react-native-cfstringtokenizer';

CFStringTokenizer.copyBestStringLanguage(msg, msgLength)
.then((bestStringLanguage: string) => {
    console.log(`Got bestStringLanguage from Swift:`, bestStringLanguage);
})
.catch((e) => console.error(e));
```

... The latter import style will also be the way to get TypeScript typings in future.