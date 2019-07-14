//
//  HelperFunctions.m
//  AvitoTask
//
//  Created by Gagik on 13/07/2019.
//  Copyright © 2019 Gagik Avetisyan. All rights reserved.
//

#import "HelperFunctions.h"

@implementation HelperFunctions

- (instancetype)initWithPath:(NSURL *)url
{
    self = [super init];
    if (self) {
        _mainPath = url;
    }
    return self;
}

- (NSDictionary *)setValueFor:(NSDictionary *)structure from:(NSArray *)druftValues
{
    //There no values
    structure = [structure mutableCopy];
    NSMutableArray *values = [structure valueForKey:@"values"];// will be converted to mutable later? if needed
    [self structureAbortIfNil:structure[@"value"]];
    [self structureAbortIfNil:structure[@"id"]];
    if (!values)
    {
        NSString *value = (NSString *)[HelperFunctions findDictionaryById:[[structure valueForKey:@"id"] integerValue] inArray:druftValues];
        if (value) [structure setValue:value forKey:@"value"];
        return structure;
    }
    
    //Set from values
    NSNumber *valNum = (NSNumber *)[HelperFunctions findDictionaryById:[[structure valueForKey:@"id"] integerValue] inArray:druftValues];
    NSString *value = (NSString *)[HelperFunctions findDictionaryById:[valNum integerValue] inArray:values];
    if (value) [structure setValue:value forKey:@"value"];
    
    //Check for params inside
    NSArray *params = [values[0] valueForKey:@"params"];
    if (!params) return structure;
    
    
    //Set values inside recurse
    values = [values mutableCopy];
    for (NSInteger i = 0; i < [values count]; i++) {
        NSMutableArray *insideParam = [[values[i] valueForKey:@"params"] mutableCopy];
        [self structureAbortIfNil:insideParam];
        for (NSInteger j = 0; j < [insideParam count]; j++) {
            NSDictionary *oneInsideParam = [self setValueFor:insideParam[j] from:druftValues];
            [self structureAbortIfNil:oneInsideParam];
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


- (NSDictionary *)readFileInLocalPath:(NSString *)path;
{
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:path relativeToURL: self.mainPath];
    NSData *structureData = [NSData dataWithContentsOfURL:url options: 0 error:&error];
    if (error)
    {
        NSLog(@"Reading Error: %@", error);
        abort();
    }
    return [NSJSONSerialization JSONObjectWithData:structureData options:kNilOptions error:nil];
}

- (void)writeDictionary:(NSDictionary *)dictionary inLocalPath:(NSString *)path
{
    NSError *error;
    NSURL *url = [NSURL fileURLWithPath:path relativeToURL: self.mainPath];
    [[NSFileManager defaultManager] createFileAtPath:url.absoluteString contents:nil attributes:nil];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:0 error:&error];
    [data writeToURL:url atomically:YES];
    return;
}

- (void)structureAbortIfNil:(id)object
{
    if (!object)
    {
        NSDictionary *error = @{@"error":
                                    @{
                                        @"message":@"Входные файлы некорректны"
                                        }
                                };
        [self writeDictionary:error inLocalPath:@"error.json"];
        abort();
    }
}

@end
