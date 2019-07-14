//
//  HelperFunctions.h
//  AvitoTask
//
//  Created by Gagik on 13/07/2019.
//  Copyright © 2019 Gagik Avetisyan. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface HelperFunctions : NSObject

+ (NSDictionary *)setValueFor:(NSDictionary *)structure from:(NSArray *)druftValues;

+ (NSDictionary *)readFile:(NSURL *)url;
+ (void)writeDictionary:(NSDictionary *)dictionary inURL:(NSURL *)url;

@end

NS_ASSUME_NONNULL_END
