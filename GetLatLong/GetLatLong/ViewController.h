//
//  ViewController.h
//  GetLatLong
//
//  Created by Ashish Chauhan on 07/12/15.
//  Copyright © 2015 Ashish Chauhan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import<MapKit/MapKit.h>


@interface ViewController : UIViewController<CLLocationManagerDelegate,MKMapViewDelegate>
{
   
}
@property (nonatomic, strong) IBOutlet MKMapView *mapView;


@property (strong, nonatomic) IBOutlet UILabel *lbllat;
@property (strong, nonatomic) IBOutlet UILabel *lbllong;

@end

