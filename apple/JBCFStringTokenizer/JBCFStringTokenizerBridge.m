//
//  JBCFStringTokenizerBridge.m
//  JBCFStringTokenizer
//
//  Created by jamie on 17/05/2018.
//  Copyright © 2018 Bottled Logic. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <React/RCTBridgeModule.h>

@interface RCT_EXTERN_MODULE(JBCFStringTokenizer, NSObject)

RCT_EXTERN_METHOD(addEvent:(NSString *)name location:(NSString *)location date:(NSNumber *)date)

@end
