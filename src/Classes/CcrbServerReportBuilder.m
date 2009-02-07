//
//  Copyright 2009 High Order Bit, Inc.. All rights reserved.
//

#import "CcrbServerReportBuilder.h"
#import "ServerReport.h"
#import "ProjectReport.h"
#import "NSDate+BuildServiceAdditions.h"
#import "TouchXML.h"

@interface CcrbServerReportBuilder (Private)
+ (NSString *)projectNameFromProjectTitle:(NSString *)projectTitle;
+ (BOOL)buildSucceededFromProjectTitle:(NSString *)projectTitle;
@end

@implementation CcrbServerReportBuilder

- (ServerReport *)serverReportFromData:(NSData *)data
{
    ServerReport * report = [ServerReport report];

    NSLog(@"Parsing XML received from server: '%@'.",
          [[[NSString alloc]
            initWithData:data encoding:NSUTF8StringEncoding]
           autorelease]);
    CXMLDocument * xml = [[CXMLDocument alloc]
        initWithData:data options:0 error:nil];

    NSArray * channels = [[xml rootElement] elementsForName:@"channel"];
    NSAssert1(channels.count == 1, @"Expected 1 element in 'channel' node, but "
        "got %d from server.", channels.count);

    CXMLElement * channel = [channels objectAtIndex:0];

    report.name =
        [[[channel elementsForName:@"title"] objectAtIndex:0] stringValue];
    report.link =
        [[[channel elementsForName:@"link"] objectAtIndex:0] stringValue];


    NSArray * projectNodes = [channel elementsForName:@"item"];
    NSMutableArray * projectReports =
        [NSMutableArray arrayWithCapacity:projectNodes.count];

    for (CXMLElement * projectNode in projectNodes) {
        ProjectReport * projectReport = [ProjectReport report];

        projectReport.name = 
            [[self class] projectNameFromProjectTitle:
             [[[projectNode elementsForName:@"title"]
                              objectAtIndex:0] stringValue]];
        projectReport.description =
             [[[projectNode elementsForName:@"description"]
                              objectAtIndex:0] stringValue];
        projectReport.pubDate =
            [NSDate dateFromCruiseControlRbString:
             [[[projectNode elementsForName:@"pubDate"]
                              objectAtIndex:0] stringValue]];
        projectReport.link =
             [[[projectNode elementsForName:@"link"]
                              objectAtIndex:0] stringValue];
        projectReport.buildSucceeded =
            [[self class] buildSucceededFromProjectTitle:
             [[[projectNode elementsForName:@"title"]
                              objectAtIndex:0] stringValue]];

        [projectReports addObject:projectReport];
    }

    report.projectReports = projectReports;

    return report;
}

#pragma mark Functions to help extract project attributes from XML data

+ (NSString *)projectNameFromProjectTitle:(NSString *)projectTitle
{
    static NSString * BUILD_STRING = @" build";

    NSRange where = [projectTitle rangeOfString:BUILD_STRING];
    if (NSEqualRanges(where, NSMakeRange(NSNotFound, 0)))
        return projectTitle;

    return [projectTitle substringWithRange:NSMakeRange(0, where.location)];
}

+ (BOOL)buildSucceededFromProjectTitle:(NSString *)projectTitle
{
    static NSString * FAILED_STRING = @"failed";

    NSRange where = [projectTitle rangeOfString:FAILED_STRING];
    return NSEqualRanges(where, NSMakeRange(NSNotFound, 0));
}

@end