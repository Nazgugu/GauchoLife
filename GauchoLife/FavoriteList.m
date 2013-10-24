//
//  GameResult.m
//  Matchismo
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University.
//  All rights reserved.
//

#import "FavoriteList.h"

@interface FavoriteList()
//@property (readwrite, nonatomic) NSString *DishTitle;
//@property (readwrite, nonatomic) NSString *Description;
@end

@implementation FavoriteList

#define ALL_RESULTS_KEY @"GameResult_All"
#define START_KEY @"StartDate"
#define END_KEY @"EndDate"
#define SCORE_KEY @"Score"


+ (NSArray *)allFavoriteClassResults
{
    return nil;
}

+ (NSArray *)allFavoriteEventsResults

{
    return nil;
}

+ (NSArray *)allFavoriteResults
{
    NSMutableArray *allGameResults = [[NSMutableArray alloc] init];
    
    for (id plist in [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] allValues]) {
        FavoriteList *result = [[FavoriteList alloc] initFromPropertyList:plist];
        [allGameResults addObject:result];
    }
    
    return allGameResults;
}

+ (void)removeDishWithTitle:(NSString *)TiltleDescrption
{
    NSMutableDictionary *tempDictionary = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    [tempDictionary removeObjectForKey:TiltleDescrption];
    [[NSUserDefaults standardUserDefaults] setObject:tempDictionary forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

// convenience initializer
- (id)initFromPropertyList:(id)plist
{
    self = [self init];
    if (self) {
        if ([plist isKindOfClass:[NSDictionary class]]) {
            NSDictionary *resultDictionary = (NSDictionary *)plist;
            _DishTitle = resultDictionary[START_KEY];
            _Description = resultDictionary[END_KEY];
            _index = [resultDictionary[SCORE_KEY] intValue];
            if (!_DishTitle || !_Description) self = nil;
        }
    }
    return self;
}

- (void)synchronize
{
    NSMutableDictionary *mutableGameResultsFromUserDefaults = [[[NSUserDefaults standardUserDefaults] dictionaryForKey:ALL_RESULTS_KEY] mutableCopy];
    if (!mutableGameResultsFromUserDefaults)
        mutableGameResultsFromUserDefaults = [[NSMutableDictionary alloc] init];
    mutableGameResultsFromUserDefaults[[self.DishTitle description]] = [self asPropertyList];
    [[NSUserDefaults standardUserDefaults] setObject:mutableGameResultsFromUserDefaults forKey:ALL_RESULTS_KEY];
    //[[NSUserDefaults standardUserDefaults] setObject:nil forKey:ALL_RESULTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (id)asPropertyList
{
    return @{ START_KEY : self.DishTitle, END_KEY : self.Description, SCORE_KEY : @(self.index) };
}

// designated initializer
- (id)init
{
    self = [super init];
    if (self) {
        _DishTitle = @"";
        _Description = @"";
    }
    return self;
}

/*- (NSTimeInterval)duration
{
    return [self.end timeIntervalSinceDate:self.start];
}*/

/*- (void)setIndex:(int)index
{
    _index = index;
    NSLog(@"badgeIndex = %d",index);
    [self synchronize];
}*/

/*-(void)setDishTitle:(NSString *)DishTitle
{
    _DishTitle = DishTitle;
    [self synchronize];
}*/

-(void)setDescription:(NSString *)Description
{
    _Description = Description;
    [self synchronize];
}

// added after lecture

#pragma mark - Sorting

/*- (NSComparisonResult)compareScoreToGameResult:(FavoriteList *)otherResult
{
    if (self.score > otherResult.score) {
        return NSOrderedAscending;
    } else if (self.score < otherResult.score) {
        return NSOrderedDescending;
    } else {
        return NSOrderedSame;
    }
}

- (NSComparisonResult)compareEndDateToGameResult:(FavoriteList *)otherResult
{
    return [otherResult.end compare:self.end];
}

- (NSComparisonResult)compareDurationToGameResult:(FavoriteList *)otherResult
{
    if (self.duration > otherResult.duration) {
        return NSOrderedDescending;
    } else if (self.duration < otherResult.duration) {
        return NSOrderedAscending;
    } else {
        return NSOrderedSame;
    }
}*/

@end
