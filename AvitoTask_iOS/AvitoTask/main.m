//
//  main.m
//  AvitoTask
//
//  Created by Gagik on 13/07/2019.
//  Copyright © 2019 Gagik Avetisyan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HelperFunctions.h"

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        //NSURL *base = [[NSBundle mainBundle] resourceURL];
        //Так как приложение Xcode в режиме debug запускается не в локальной директории, то для запуска ввести сюда свой путь, в собранном бинарнике используется строка выше для получения локлаьной директории
        NSURL *base = [NSURL fileURLWithPath:@"/Users/theeska/Desktop/GitRepo/AvitoTask_iOS/AvitoTask_iOS/AvitoTask/"];
        HelperFunctions *helper = [[HelperFunctions alloc] initWithPath:base];
        NSDictionary *structure = [helper readFileInLocalPath:@"Structure.json"];
        NSDictionary *draftValue = [helper readFileInLocalPath:@"Draft_values.json"];
        
        NSArray *draftValues = [draftValue valueForKey:@"values"];
    
        NSMutableArray *params = [[structure valueForKey:@"params"] mutableCopy];
        for (NSInteger i = 0; i < [params count]; i++) {
            NSDictionary *resultedParam = [helper setValueFor:params[i] from:draftValues];
            params[i] = resultedParam;
        }
        
        NSDictionary *result = @{@"params": params};
        [helper writeDictionary:result inLocalPath:@"Result.json"];
    }
    return 0;
}


