//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ProjectReporter.h"
#import "ProjectReporterDelegate.h"

//@class CcrbBuildForcer;
@class ProjectReportViewController;

@interface UIProjectReporter : NSObject
                               < ProjectReporter >
{
    NSObject<ProjectReporterDelegate> * delegate;
    //CcrbBuildForcer * buildForcer;

    UINavigationController * navigationController;
    ProjectReportViewController * projectReportViewController;
}

@property (nonatomic, retain) IBOutlet NSObject<ProjectReporterDelegate> *
    delegate;
//@property (nonatomic, retain) CcrbBuildForcer * buildForcer;
@property (nonatomic, retain) IBOutlet UINavigationController *
    navigationController;
@property (nonatomic, retain) ProjectReportViewController *
    projectReportViewController;

@end
