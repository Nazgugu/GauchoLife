//
//  MapViewController.m
//  REMenuExample
//
//  Created by Bernard Yan on 10/17/13.
//  Copyright (c) 2013 Roman Efimov. All rights reserved.
//



#import "MapViewController.h"

@interface MapViewController (){
    int _count;
    NAAnnotation *_lastFocused;
}
@property (nonatomic, strong) NSMutableArray *annotations;
@property (nonatomic, assign) CGSize size;

@end

@implementation MapViewController

@synthesize mapView     = _mapView;
@synthesize annotations = _annotations;
@synthesize size        = _size;

/*- (UIImageView *) imageView{
    
    if (!_imageView) {
        _imageView = [[UIImageView alloc]init];
        
        NSString *thePath = [[NSBundle mainBundle] pathForResource:@"UCSBMAP" ofType:@"png"];
        UIImage *image = [[UIImage alloc]initWithContentsOfFile:thePath];
        
        self.mapScrollView.contentSize = image.size;
        self.imageView.image = image;
        self.imageView.frame = CGRectMake(0, 0, image.size.width, image.size.height);
        self.mapScrollView.maximumZoomScale = 1.2;
        self.mapScrollView.minimumZoomScale = 0.1;
        self.mapScrollView.delegate = self;
        
        
    }
    
    return _imageView;
    
    
}*/

/*- (UIView *)viewForZoomingInScrollView:(UIScrollView *)scrollView{
    
    return self.imageView;
    
}*/

-(IBAction)addPin:(id)sender{
    
    int x = (arc4random() % (int)self.size.width);
    int y = (arc4random() % (int)self.size.width);
    
    CGPoint point = CGPointMake(x, y);
    
    [self.mapView centreOnPoint:point animated:YES];
    
    NAAnnotation *annotation = [NAAnnotation annotationWithPoint:point];
    
    annotation.title = [NSString stringWithFormat:@"Pin %d", ++_count];
    
    annotation.color = arc4random() % 3;
    
    [self.mapView addAnnotation:annotation animated:YES];
    
    [self.annotations addObject:annotation];
    
    _lastFocused = annotation;
    
}

-(IBAction)removePin:(id)sender{
    
    if([self.annotations count] <= 0 || _lastFocused == nil) return;
    
    [self.mapView centreOnPoint:_lastFocused.point animated:YES];
    
    [self.mapView removeAnnotation:_lastFocused];
    
    [self.annotations removeObject:_lastFocused];
    
    _lastFocused = ([self.annotations count] > 0) ? [self.annotations objectAtIndex:[self.annotations count]-1] : nil;
}

-(IBAction)selectRandom:(id)sender{
    if([self.annotations count] <= 0) return;
    
    int rand = (arc4random() % (int)[self.annotations count]);
    NAAnnotation *annotation = [self.annotations objectAtIndex:rand];
    
    [self.mapView selectAnnotation:annotation animated:YES];
    
    _lastFocused = annotation;
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"Map";
	// Do any additional setup after loading the view.
    self.annotations = [[NSMutableArray alloc] init];
    
    UIImage *image = [UIImage imageNamed:@"UCSBMAP"];
    
    self.mapView.backgroundColor = [UIColor colorWithRed:0.000f green:0.475f blue:0.761f alpha:1.000f];
    
    [self.mapView displayMap:image];
    self.mapView.minimumZoomScale = 0.15f;
    self.mapView.maximumZoomScale = 2.0f;
    
    self.size = image.size;
    
    _count = 0;
    _lastFocused = nil;
   
    
    
    
}




@end
