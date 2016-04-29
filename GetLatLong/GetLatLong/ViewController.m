//
//  ViewController.m
//  GetLatLong
//
//  Created by Ashish Chauhan on 07/12/15.
//  Copyright © 2015 Ashish Chauhan. All rights reserved.
//

#import "ViewController.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "MapViewAnnotation.h"


@interface ViewController ()<MKMapViewDelegate,MKAnnotation>

@end

@implementation ViewController

CLLocationManager *locationManager;

// Add CoreLocation/CoreLocation fram work in project

// Add below two key in in info.plist file so it will work in ios 8 and above
// NSLocationAlwaysUsageDescription
// NSLocationWhenInUseUsageDescription

@synthesize mapView;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
//
//    locationManager = [[CLLocationManager alloc] init];
//    
//    locationManager.delegate = self;
//    if([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)]){
//        NSUInteger code = [CLLocationManager authorizationStatus];
//        if (code == kCLAuthorizationStatusNotDetermined && ([locationManager respondsToSelector:@selector(requestAlwaysAuthorization)] || [locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)])) {
//            // choose one request according to your business.
//            if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationAlwaysUsageDescription"]){
//                [locationManager requestAlwaysAuthorization];
//            } else if([[NSBundle mainBundle] objectForInfoDictionaryKey:@"NSLocationWhenInUseUsageDescription"]) {
//                [locationManager  requestWhenInUseAuthorization];
//            } else {
//                NSLog(@"Info.plist does not contain NSLocationAlwaysUsageDescription or NSLocationWhenInUseUsageDescription");
//            }
//        }
//    }
//    [locationManager startUpdatingLocation];
    
    

    
    
//   // mapView = [[MKMapView alloc]initWithFrame:
//     //          CGRectMake(10, 100, 300, 300)];
//    mapView.delegate = self;
//    mapView.centerCoordinate = CLLocationCoordinate2DMake(37.32, -122.03);
//   // mapView.mapType = MKMapTypeHybrid;
//    CLLocationCoordinate2D location;
//    location.latitude = (double) 23.0300;
//    location.longitude = (double) 72.5800;
//    // Add the annotation to our map view
//    MapViewAnnotation *newAnnotation = [[MapViewAnnotation alloc]initWithTitle:@"Ahmedabad" AndCoordinate:location];
//                                    
//    [mapView addAnnotation:newAnnotation];
//    CLLocationCoordinate2D location2;
//    location2.latitude = (double) 18.9750;
//    location2.longitude = (double) 72.8258;
//    MapViewAnnotation *newAnnotation2 = [[MapViewAnnotation alloc]initWithTitle:@"Welcom to Mumbai,Welcom to Bombay,Welcom to Mumbai,Welcom to Bombay,Welcom to Mumbai,Welcom to Ahmedabad,Welcom to kerala,Welcom to Pune," AndCoordinate:location2];
//    [mapView addAnnotation:newAnnotation2];
//    [self.view addSubview:mapView];
//    
//    NSLog(@"Loaded map");
//    
    
    
    NSString *urlString = @"https://selfcareapps.tatatel.co.in:8080/SelfcareServices/getAllStores";
  
    NSString *postString = [NSString stringWithFormat:@"%@?Circle=%@&City=%@",urlString,@"Gujarat",@"Ahmedabad"];
    NSLog(@"postString is : %@",postString);
    
    NSURL *url = [NSURL URLWithString:[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSLog(@"url created is : %@",url);
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringCacheData
                                                       timeoutInterval:120.0];
    
    NSURLResponse *response = nil;
    
    NSError *error;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];
    
    NSArray *jsonResponse = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:nil];
    
    
        CLLocationCoordinate2D coordinate;
    NSArray *longitude = [jsonResponse valueForKey:@"longitude"];
        NSArray *lattitude = [jsonResponse valueForKey:@"latitude"];
        NSArray *address = [jsonResponse valueForKey:@"address1"];
    
    NSLog(@"map selected");
    for(int j = 0;j<longitude.count;j++){
        
        NSString *lat = [lattitude objectAtIndex:j];
        NSString *longi = [longitude objectAtIndex:j];
        coordinate.latitude =[lat doubleValue];
        coordinate.longitude = [longi doubleValue];
        
        self.mapView.centerCoordinate = CLLocationCoordinate2DMake(coordinate.latitude, coordinate.longitude);
        self.mapView.zoomEnabled = YES;
        
        //            NSAttributedString *atrStr = [[NSAttributedString alloc]initWithString:@"\ndays\ndars\nview" attributes:@{NSFontAttributeName : [UIFont fontWithName:@"HelveticaNeue-Bold" size:8]}];
        
        
        MKPointAnnotation *point = [[MKPointAnnotation alloc] init];
        point.coordinate = mapView.centerCoordinate;
        point.title = [address objectAtIndex:j];
        [self moveMapToAnnotation:point];
        [self.mapView addAnnotation:point];

  
}

}


- (void)moveMapToAnnotation:(MKPointAnnotation*)annotation
{
    CGFloat fractionLatLon = mapView.region.span.latitudeDelta / mapView.region.span.longitudeDelta;
    CGFloat newLatDelta = 0.16f;
    CGFloat newLonDelta = newLatDelta * fractionLatLon;
    MKCoordinateRegion region = MKCoordinateRegionMake(annotation.coordinate, MKCoordinateSpanMake(newLatDelta, newLonDelta));
    [mapView setRegion:region animated:YES];
}

//
//- (void)mapView:(MKMapView *)mv didAddAnnotationViews:(NSArray *)views
//{
//    
//    for (int i = 0; i<views.count; i++) {
//        
//        NSLog(@"....i val %d",i);
//        
//        MKAnnotationView *annotationView = [views objectAtIndex:i];
//        id <MKAnnotation> mp = [annotationView annotation];
//        MKCoordinateRegion region = MKCoordinateRegionMakeWithDistance
//        ([mp coordinate], 100, 100);
//        [mv setRegion:region animated:YES];
//        [mv selectAnnotation:mp animated:YES];
//
//        
//    }
//    
//}





- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"didFailWithError: %@", error);
    UIAlertView *errorAlert = [[UIAlertView alloc]
                               initWithTitle:@"Error" message:@"Failed to Get Your Location" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [errorAlert show];
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    NSLog(@"didUpdateToLocation: %@", newLocation);
    CLLocation *currentLocation = newLocation;
    
    if (currentLocation != nil) {
        _lbllong.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.longitude];
        _lbllat.text = [NSString stringWithFormat:@"%.8f", currentLocation.coordinate.latitude];
    }
    
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(currentLocation.coordinate.longitude,currentLocation.coordinate.latitude);
    
    MKCoordinateSpan span = MKCoordinateSpanMake(0.1, 0.1);
    MKCoordinateRegion region = {coord, span};
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:coord];
    
    [self.mapView setRegion:region];
    [self.mapView addAnnotation:annotation];

    
    
   
}





- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
