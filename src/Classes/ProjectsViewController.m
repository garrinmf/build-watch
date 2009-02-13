//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "ProjectsViewController.h"

@interface ProjectsViewController (Private)
- (void) setVisibleProjects:(NSArray *)someVisibleProjects;
- (void) updateVisibleProjects;
@end

@implementation ProjectsViewController

@synthesize tableView;
@synthesize projects;
@synthesize delegate;

- (void) dealloc
{
    [tableView release];
    [projects release];
    [visibleProjects release];
    [delegate release];
    [super dealloc];
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    NSLog(@"%@: Awaking from nib.", self);
}

- (void) viewDidLoad
{
    [super viewDidLoad];
    
    [self.navigationItem setRightBarButtonItem:self.editButtonItem animated:NO];
}

- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    self.navigationItem.title = [delegate displayNameForCurrentProjectGroup];

    NSIndexPath * selectedRow = [tableView indexPathForSelectedRow];
    [tableView deselectRowAtIndexPath:selectedRow animated:NO];
}

- (void) viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [delegate userDidDeselectServerGroupName];
}

#pragma mark UITableViewDelegate

- (NSInteger) numberOfSectionsInTableView:(UITableView *)tv
{
    return 1;
}

- (NSInteger) tableView:(UITableView *)tv
  numberOfRowsInSection:(NSInteger)section
{
    return visibleProjects.count;
}

- (UITableViewCell *) tableView:(UITableView *)tv
          cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell =
        [tv dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
        cell =
            [[[UITableViewCell alloc]
              initWithFrame:CGRectZero reuseIdentifier:CellIdentifier]
             autorelease];
    
    cell.text =
        [delegate
         displayNameForProject:[visibleProjects objectAtIndex:indexPath.row]];
        
    return cell;
}

- (void)      tableView:(UITableView *)tv
didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString * project = [visibleProjects objectAtIndex:indexPath.row];
    if (!self.editing)
        [delegate userDidSelectProject:project];
    else {
        BOOL currentTrackedState = [delegate trackedStateForProject:project];
        [delegate setTrackedState:!currentTrackedState onProject:project];
        
        UITableViewCell * cell = [tv cellForRowAtIndexPath:indexPath];
        cell.accessoryType =
            [self tableView:tv accessoryTypeForRowWithIndexPath:indexPath];

        [tv deselectRowAtIndexPath:indexPath animated:YES];
    }
}

- (UITableViewCellAccessoryType) tableView:(UITableView *)tv
          accessoryTypeForRowWithIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCellAccessoryType editAccessoryType =
        [visibleProjects count] > 0 && [delegate trackedStateForProject:
        [visibleProjects objectAtIndex:indexPath.row]] ?
        UITableViewCellAccessoryCheckmark :
        UITableViewCellAccessoryNone;
    
    return self.editing ?
        editAccessoryType :
        UITableViewCellAccessoryDisclosureIndicator;
}

#pragma mark Accessors

- (void) setProjects:(NSArray *)someProjects
{
    [projects release];
    projects = [someProjects retain];

    [self updateVisibleProjects];
    
    [tableView reloadData];
}

- (void) setVisibleProjects:(NSArray *)someVisibleProjects
{
    [someVisibleProjects retain];
    [visibleProjects release];
    visibleProjects = someVisibleProjects;
}

#pragma mark Project manipulation

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{    
    [super setEditing:editing animated:animated];
    
    [self updateVisibleProjects];
    
    NSMutableArray * indexPathsOfHidden = [NSMutableArray array];
    for (NSInteger i = 0; i < projects.count; ++i) {
        NSString * project = [projects objectAtIndex:i];
        if (![delegate trackedStateForProject:project])
            [indexPathsOfHidden addObject:
             [NSIndexPath indexPathForRow:i inSection:0]];
    }
    
    [tableView beginUpdates];
    
    if (editing)
        [tableView insertRowsAtIndexPaths:indexPathsOfHidden
                         withRowAnimation:UITableViewRowAnimationTop];
    else
        [tableView deleteRowsAtIndexPaths:indexPathsOfHidden
                         withRowAnimation:UITableViewRowAnimationTop];
    
    [tableView endUpdates];
    
    [tableView reloadData];
}

#pragma mark Private helper functions

- (void) updateVisibleProjects
{
    if (!self.editing) {
        NSMutableArray * tempVisibleProjects = [[NSMutableArray alloc] init];
        for (NSString * project in projects)
            if ([delegate trackedStateForProject:project])
                [tempVisibleProjects addObject:project];
        [self setVisibleProjects:tempVisibleProjects];
    }
    else
        [self setVisibleProjects:projects];
}

@end
