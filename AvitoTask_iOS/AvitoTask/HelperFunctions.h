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

@property (nonatomic, strong) NSURL *mainPath;

- (instancetype)initWithPath:(NSURL *)url;

- (NSDictionary *)readFileInLocalPath:(NSString *)path;
- (void)writeDictionary:(NSDictionary *)dictionary inLocalPath:(NSString *)path;

/**
 Parser

 @param structure one param
 @param druftValues array of values with ids
 @return structure with values
 */
- (NSDictionary *)setValueFor:(NSDictionary *)structure from:(NSArray *)druftValues;

@end

NS_ASSUME_NONNULL_END
