//
//  RNCFStringTokenizerBridge.m
//  RNCFStringTokenizer
//
//  Created by Jamie Birch (shirakaba) on 17/05/2018.
//  Copyright © 2018 Jamie Birch. All rights reserved.
//

#import <Foundation/Foundation.h>
// #import <React/RCTBridge.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(RNCFStringTokenizer, NSObject)

// RCT_EXTERN_METHOD(addEvent:(NSString *)name location:(NSString *)location date:(nonnull NSNumber *)date callback: (RCTResponseSenderBlock)callback);

// https://stackoverflow.com/a/42874301/5951226 : "Got “is not a recognized Objective-C method” when bridging Swift to React-Native"
// https://stackoverflow.com/a/24046893/5951226 : unnamed params
// static methods are represented with + rather than -.
// https://stackoverflow.com/questions/36309596/swift-ambiguos-methods-with-variadic-paramameter
RCT_EXTERN_METHOD(copyBestStringLanguage:(NSString *)string :(NSNumber *)length)

@end