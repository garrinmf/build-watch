//
//  Copyright High Order Bit, Inc. 2009. All rights reserved.
//

#import "ProjectTableViewCell.h"
#import "UIColor+BuildWatchColors.h"
#import "NSDate+IsToday.h"
#import "NSDate+StringHelpers.h"

@interface ProjectTableViewCell (Private)

- (void) updateUnselectedStyle;

- (UIColor *) currentBuildSucceededColor;

- (void) updateBuildStatusLabelText;

+ (UIColor *) untrackedColor;

+ (UIColor *) buildSucceededColor;

+ (UIColor *) buildFailedColor;

@end

@implementation ProjectTableViewCell

- (void) dealloc
{
    [nameLabel release];
    [buildStatusLabel release];
    [pubDateLabel release];
    [buildLabel release];
    [pubDate release];
    [super dealloc];
}

- (void) awakeFromNib
{
    self.contentView.clipsToBounds = YES;
}

- (void) setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
        
    if (selected) {
        nameLabel.textColor = self.selectedTextColor;
        buildStatusLabel.textColor = self.selectedTextColor;
        pubDateLabel.textColor = self.selectedTextColor;
    } else
        [self updateUnselectedStyle];
}

- (void) setName:(NSString *)name
{
    nameLabel.text = name;
}

- (void) setBuildStatusText:(NSString *)text
{
    buildStatusLabel.text = text;
}

- (void) setBuildSucceeded:(BOOL)newBuildSucceeded
{
    buildSucceeded = newBuildSucceeded;
    
    [self updateBuildStatusLabelText];
    
    if (!self.selected)
        [self updateUnselectedStyle];
}

- (void) setBuildLabel:(NSString *)newBuildLabel
{
    NSString * tempBuildLabel = [[newBuildLabel copy] retain];
    [buildLabel release];
    buildLabel = tempBuildLabel;
    
    [self updateBuildStatusLabelText];
}

- (void) setTracked:(BOOL)newTracked
{
    tracked = newTracked;
    if (!self.selected)
        [self updateUnselectedStyle];
}

- (void) updateBuildStatusLabelText
{
    NSString * statusDesc = buildSucceeded ? @"succeeded" : @"failed";
    buildStatusLabel.text =
        [NSString stringWithFormat:@"Build %@ %@", buildLabel, statusDesc];
}

- (void) setPubDate:(NSDate *)newPubDate
{
    NSDate * tempPubDate = [[newPubDate copy] retain];
    [pubDate release];
    pubDate = tempPubDate;
    
    pubDateLabel.text = [pubDate shortDescription];
    
    if (!self.selected)
        [self updateUnselectedStyle];
}

#pragma mark Private helper functions

- (void) updateUnselectedStyle
{
    nameLabel.textColor =
        tracked ? [UIColor blackColor] : [[self class] untrackedColor];
    buildStatusLabel.textColor =
        tracked ? [self currentBuildSucceededColor] :
        [[self class] untrackedColor];
    pubDateLabel.textColor =
        tracked ? [UIColor buildWatchBlueColor] : [[self class] untrackedColor];
}

- (UIColor *) currentBuildSucceededColor
{
    return buildSucceeded ?
        [[self class] buildSucceededColor] : [[self class] buildFailedColor];
}

#pragma mark Private static helper functions

+ (UIColor *) untrackedColor
{
    return [UIColor grayColor];
}

+ (UIColor *) buildSucceededColor
{
    return [UIColor buildWatchGreenColor];
}

+ (UIColor *) buildFailedColor
{
    return [UIColor buildWatchRedColor];
}

@end
