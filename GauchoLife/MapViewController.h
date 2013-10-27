//
//  MapViewController.h
//  REMenuExample
//
//  Created by Bernard Yan on 10/17/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//

#import "RootViewController.h"
#import "NAMapView.h"

@interface MapViewController : RootViewController
@property (nonatomic, weak) IBOutlet NAMapView *mapView;

-(IBAction)addPin:(id)sender;
-(IBAction)removePin:(id)sender;
-(IBAction)selectRandom:(id)sender;

@end