//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BuildWatchPersistentStore.h"

@interface MockBuildWatchPersistentStore : NSObject
                                       < BuildWatchPersistentStore >
{
    NSDictionary * servers;
    NSDictionary * serverNames;
    NSDictionary * projectDisplayNames;
}

@end