//
//  HelperFunctions.m
//  AvitoTask
//
//  Created by Gagik on 13/07/2019.
//  Copyright © 2019 Gagik Avetisyan. All rights reserved.
//

#import "HelperFunctions.h"

@implementation HelperFunctions

+ (NSDictionary *)setValueFor:(NSDictionary *)structure from:(NSArray *)druftValues
{
    //There no values
    structure = [structure mutableCopy];
    NSMutableArray *values = [structure valueForKey:@"values"]; // will be converted to mutable later? if needed
    if (!values)
    {
        NSString *value = (NSString *)[self findDictionaryById:[[structure valueForKey:@"id"] integerValue] inArray:druftValues];
        if (value) [structure setValue:value forKey:@"value"];
        return structure;
    }
    
    //Set from values
    NSNumber *valNum = (NSNumber *)[self findDictionaryById:[[structure valueForKey:@"id"] integerValue] inArray:druftValues];
    NSString *value = (NSString *)[self findDictionaryById:[valNum integerValue] inArray:values];
    if (value) [structure setValue:value forKey:@"value"];
    
    //Check for params inside
    NSArray *params = [values[0] valueForKey:@"params"];
    if (!params) return structure;
    
    
    //Set values inside recurse
    values = [values mutableCopy];
    for (NSInteger i = 0; i < [values count]; i++) {
        NSMutableArray *insideParam = [[values[i] valueForKey:@"params"] mutableCopy];
        for (NSInteger j = 0; j < [insideParam count]; j++) {
            NSDictionary *oneInsideParam = [self setValueFor:insideParam[j] from:druftValues];
            insideParam[j] = oneInsideParam;
        }
        values[i] = insideParam;
    }
    [structure setValue:values forKey:@"values"];
    
    return structure;
}


/**
 Find dictionary with value for key "id" uqual param identifier in array of dictionaries
 
 @param identidier value for key "id"
 @param array of dictionaries
 @return dictionary
 */
+ (id)findDictionaryById:(NSInteger)identidier inArray:(NSArray *)array
{
    for (NSDictionary *kv in array) {
        NSNumber *curID = [kv valueForKey:@"id"];
        if ([curID integerValue] == identidier)
        {
            return [kv valueForKey:@"value"] ? : [kv valueForKey:@"title"];
        }
    }
    return nil;
}


+ (NSDictionary *)readFile:(NSURL *)url
{
    NSError *error;
    NSData *structureData = [NSData dataWithContentsOfURL:url options: 0 error:&error];
    if (error)
    {
        NSLog(@"Reading Error: %@", error);
        abort();
    }
    return [NSJSONSerialization JSONObjectWithData:structureData options:kNilOptions error:nil];
}

+ (void)writeDictionary:(NSDictionary *)dictionary inURL:(NSURL *)url
{
    NSError *error;
    [[NSFileManager defaultManager] createFileAtPath:url.absoluteString contents:nil attributes:nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    [data writeToURL:url atomically:YES];
    return;
}

@end
