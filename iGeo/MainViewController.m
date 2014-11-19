//
//  MainViewController.m
//  iGeo
//
//  Created by Sumeet Ungratwar on 11/15/14.
//  Copyright (c) 2014 Sumeet Ungratwar. All rights reserved.
//

#import "MainViewController.h"
#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "Annotation.h"
#import "InstagramClient.h"
#import "Location.h"
#import "IGImage.h"
#import "LocationDetailViewController.h"

@interface MainViewController () <MKMapViewDelegate, CLLocationManagerDelegate, UIPageViewControllerDelegate>

@property (weak, nonatomic) IBOutlet MKMapView *mapView;
@property(nonatomic, retain) CLLocationManager *locationManager;
@property(nonatomic, strong) MKPinAnnotationView *selectedView;
@property(nonatomic, strong) NSArray *mediaToShow;
@property(nonatomic, strong) Location *selectedLocation;
@property(nonatomic, assign) MKCoordinateRegion currentRegion;

- (void) addPins:(float)latitute longitude:(float)longitude adjustView:(BOOL)adjustView;

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self setupMapView];
    
    //lat=48.858844&lng=2.294351
    //[self addPins:48.858844 longitude:2.294351 adjustView:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) addPins:(float)latitute longitude:(float)longitude adjustView:(BOOL)adjustView {
    [[InstagramClient sharedInstance] searchLocationsByCoordinate:latitute longtitude:longitude completion:^(NSArray *locations, NSError *error) {
        if (error == nil) {
            //NSLog(@"Successfully got the locations %@ ", locations);
            
            for (Location *location in locations) {
                // Add an annotation for each location
                //NSLog(@"%@ %f %f", location.name, location.latitude, location.longtitude);
                CLLocationCoordinate2D point;
                point.latitude = location.latitude;
                point.longitude = location.longtitude;
                Annotation *an = [[Annotation alloc] init];
                an.coordinate = point;
                an.title = location.name;
                an.location = location;
                [self.mapView addAnnotation:an];
            }
            if (adjustView) {
                [self zoomMapViewToFitAnnotations:self.mapView animated:YES];
                self.currentRegion = [self.mapView region];
            }
        } else {
            NSLog(@"Could not get locations %@", error);
        }
    }];
}

- (void)removeAllPinsButUserLocation
{
    id userLocation = [self.mapView userLocation];
    NSMutableArray *pins = [[NSMutableArray alloc] initWithArray:[self.mapView annotations]];
    if ( userLocation != nil ) {
        [pins removeObject:userLocation]; // avoid removing user location off the map
    }
    
    [self.mapView removeAnnotations:pins];
}

- (void)setupMapView {
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    
    // Use one or the other, not both. Depending on what you put in info.plist
    [self.locationManager requestWhenInUseAuthorization];
    
    [self.locationManager startUpdatingLocation];
    
    self.mapView.delegate = self;
    self.mapView.showsUserLocation = YES;
    
    [self.mapView setMapType:MKMapTypeStandard];
    [self.mapView setZoomEnabled:YES];
    [self.mapView setScrollEnabled:YES];
}

#pragma mark - map view delegates
- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation
{
    NSLog(@"didUpdateUserLocation");
    [self removeAllPinsButUserLocation];
    MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance(userLocation.coordinate, 80, 80);
    [self.mapView setRegion:[self.mapView regionThatFits:region] animated:YES];
    //[self addPins:userLocation.coordinate.latitude longitude:userLocation.coordinate.longitude adjustView:YES];
}

- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation
{
    Annotation *an = (Annotation *)annotation;
    //NSLog(@"title: %f", an.coordinate.latitude);
    // If the annotation is the user location, just return nil.
    
    if ([annotation isKindOfClass:[MKUserLocation class]])
        return nil;
    
    // Handle any custom annotations.
    if ([annotation isKindOfClass:[Annotation class]])
    {
        
        // Try to dequeue an existing pin view first.
        MKPinAnnotationView *pinView = (MKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:@"AnnotationView"];
        
        if (!pinView)
        {
            // If an existing pin view was not available, create one.
            pinView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"AnnotationView"];
            pinView.pinColor = MKPinAnnotationColorRed;
            pinView.animatesDrop = NO;
            pinView.canShowCallout = YES;
            
            // If appropriate, customize the callout by adding accessory views (code not shown).
            
        }
        else
            pinView.annotation = annotation;
        
        // Because this is an iOS app, add the detail disclosure button to display details about the annotation in another view.
        UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        rightButton.tag = an.location.lid;
        [rightButton addTarget:self action:@selector(showDetails:) forControlEvents:UIControlEventTouchUpInside];
        pinView.rightCalloutAccessoryView = rightButton;
        
        // Add a custom image to the left side of the callout.
        UIImageView *myCustomImage = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"mr-t-shirt.jpg"]];
        myCustomImage.frame = CGRectMake(0, 0, 50, 50);
        myCustomImage.contentMode = UIViewContentModeScaleAspectFit;
        myCustomImage.userInteractionEnabled = YES;
        pinView.leftCalloutAccessoryView = myCustomImage;
        
        return pinView;
    }
    return nil;
}

- (void)mapView:(MKMapView *)mapView didAddAnnotationViews:(NSArray *)annotationViews
{
    NSLog(@"didAddAnnotationViews");
    NSTimeInterval delayInterval = 0;
    
    for (MKAnnotationView *annView in annotationViews)
    {
        CGRect endFrame = annView.frame;
        
        //annView.frame = CGRectOffset(endFrame, 0, -500);
        annView.alpha = 0;
        
        [UIView animateWithDuration:0.6
                              delay:delayInterval
                            options:UIViewAnimationOptionAllowUserInteraction
                         animations:^{ annView.frame = endFrame; annView.alpha = 1;}
                         completion:NULL];
        
        delayInterval += 0.1;
    }
}

- (void)mapView:(MKMapView *)mapView didSelectAnnotationView:(MKAnnotationView *)view NS_AVAILABLE(10_9, 4_0) {
    NSLog(@"selected annotation view");
    
    Annotation *an = (Annotation *)view.annotation;
    
    // If the annotation is the user location, do nothing.
    
    if ([an isKindOfClass:[MKUserLocation class]]) {
        return;
    }
    
    // Handle any custom annotations.
    if ([an isKindOfClass:[Annotation class]])
    {
        NSLog(@"Location %@ got selected", an.location.name);
        self.selectedView = (MKPinAnnotationView *)view;
        
        [[InstagramClient sharedInstance] recentMediaOfLocation:an.location.lid completion:^(NSArray *media, NSError *error) {
            if (error == nil) {
                NSLog(@"Successfully got media for location %ld", an.location.lid);
                
                self.mediaToShow = media;
                if (media.count > 0) {
                    self.selectedLocation = an.location;
                } else {
                    self.selectedView.rightCalloutAccessoryView.hidden = YES;
                    //self.selectedView.callout
                }
                
                //NSLog(@"selected media: %@", media);
                
            } else {
                NSLog(@"Could not get media for location %ld", an.location.lid);
            }
        }];
    }
    
}

- (void)mapView:(MKMapView *)mapView regionDidChangeAnimated:(BOOL)animated {
    MKCoordinateRegion region = [self.mapView region];
    
    
    CLLocation *oldCenter = [[CLLocation alloc] initWithLatitude:self.currentRegion.center.latitude longitude:self.currentRegion.center.longitude];
    CLLocation *newCenter = [[CLLocation alloc] initWithLatitude:region.center.latitude longitude:region.center.longitude];
    
    self.currentRegion = [self.mapView region];
    
    if (region.span.latitudeDelta > 10) {
        NSLog(@"Too above the ground. Doesn't make sense to show locations");
        return;
    }
    
    NSLog(@"%f %f %f %f", fabs(oldCenter.coordinate.latitude - newCenter.coordinate.latitude), region.span.latitudeDelta / 2, fabsf(oldCenter.coordinate.longitude - newCenter.coordinate.longitude), region.span.longitudeDelta / 2);
    if (fabsf(oldCenter.coordinate.latitude - newCenter.coordinate.latitude) > region.span.latitudeDelta / 4 || fabsf(oldCenter.coordinate.longitude - newCenter.coordinate.longitude) > region.span.longitudeDelta / 4) {
        NSLog(@"Center moved enough");
        [self addPins:region.center.latitude longitude:region.center.longitude adjustView:NO];
    } else {
        NSLog(@"Center did not move enough");
    }
    
    
}

#define MINIMUM_ZOOM_ARC 0.014 //approximately 1 miles (1 degree of arc ~= 69 miles)
#define ANNOTATION_REGION_PAD_FACTOR 1.15
#define MAX_DEGREES_ARC 360
//size the mapView region to fit its annotations
- (void)zoomMapViewToFitAnnotations:(MKMapView *)mapView animated:(BOOL)animated
{
    NSArray *annotations = mapView.annotations;
    NSUInteger count = [mapView.annotations count];
    NSLog(@"#annotations: %ld", count);
    if ( count == 0) { return; } //bail if no annotations
    
    
    
    //convert NSArray of id <MKAnnotation> into an MKCoordinateRegion that can be used to set the map size
    //can't use NSArray with MKMapPoint because MKMapPoint is not an id
    MKMapPoint points[count]; //C array of MKMapPoint struct
    for( int i=0; i<count; i++ ) //load points C array by converting coordinates to points
    {
        CLLocationCoordinate2D coordinate = [(id <MKAnnotation>)[annotations objectAtIndex:i] coordinate];
        points[i] = MKMapPointForCoordinate(coordinate);
    }
    //create MKMapRect from array of MKMapPoint
    MKMapRect mapRect = [[MKPolygon polygonWithPoints:points count:count] boundingMapRect];
    //convert MKCoordinateRegion from MKMapRect
    MKCoordinateRegion region = MKCoordinateRegionForMapRect(mapRect);
    
    //add padding so pins aren't scrunched on the edges
    region.span.latitudeDelta  *= ANNOTATION_REGION_PAD_FACTOR;
    region.span.longitudeDelta *= ANNOTATION_REGION_PAD_FACTOR;
    //but padding can't be bigger than the world
    if( region.span.latitudeDelta > MAX_DEGREES_ARC ) { region.span.latitudeDelta  = MAX_DEGREES_ARC; }
    if( region.span.longitudeDelta > MAX_DEGREES_ARC ){ region.span.longitudeDelta = MAX_DEGREES_ARC; }
    
    //and don't zoom in stupid-close on small samples
    if( region.span.latitudeDelta  < MINIMUM_ZOOM_ARC ) { region.span.latitudeDelta  = MINIMUM_ZOOM_ARC; }
    if( region.span.longitudeDelta < MINIMUM_ZOOM_ARC ) { region.span.longitudeDelta = MINIMUM_ZOOM_ARC; }
    //and if there is a sample of 1 we want the max zoom-in instead of max zoom-out
    if( count == 1 )
    {
        region.span.latitudeDelta = MINIMUM_ZOOM_ARC;
        region.span.longitudeDelta = MINIMUM_ZOOM_ARC;
    }
    [mapView setRegion:region animated:animated];
}

- (void)onTapShowDetails:(int)tag sender:(id)sender {
    UIButton *button = (UIButton *)sender;
    NSLog(@"showDetails tag: %ld", button.tag);
}

- (void)showDetails:(id)sender {
    if (self.mediaToShow.count > 0) {
        UIButton *button = (UIButton *)sender;
        NSLog(@"showDetails tag: %ld", button.tag);
        
        LocationDetailViewController *ldvc = [[LocationDetailViewController alloc] init];
        UINavigationController *nvc = [[UINavigationController alloc] initWithRootViewController:ldvc];
        ldvc.medias = self.mediaToShow;
        ldvc.locationName = self.selectedLocation.name;
        [self presentViewController:nvc animated:YES completion:nil];
    }
}

- (void)handleDrag:(UIPanGestureRecognizer *)gestureRecognizer {
    
    NSLog(@"handleDrag got called");
    if (gestureRecognizer.state != UIGestureRecognizerStateEnded)
        return;
    
    
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

@end
