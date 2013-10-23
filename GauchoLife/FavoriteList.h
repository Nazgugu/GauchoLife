//
//  GameResult.h
//  Matchismo
//
//  Created by CS193p Instructor.
//  Copyright (c) 2013 Stanford University.
//  All rights reserved.
//

#import <Foundation/Foundation.h>

@interface FavoriteList : NSObject

+ (NSArray *)allFavoriteResults; // of GameResult
+ (void)removeDishWithTitle:(NSString *)TiltleDescrption;
@property (readwrite, nonatomic) NSString *DishTitle;
@property (readwrite, nonatomic) NSString *Description;
//@property (readonly, nonatomic) NSTimeInterval duration;
@property (nonatomic) int index;

// added after lecture

/*- (NSComparisonResult)compareScoreToGameResult:(FavoriteList *)otherResult;
- (NSComparisonResult)compareEndDateToGameResult:(FavoriteList *)otherResult;
- (NSComparisonResult)compareDurationToGameResult:(FavoriteList *)otherResult;*/

@end
