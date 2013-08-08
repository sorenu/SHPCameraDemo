//
//  ViewController.m
//  SHPCameraDemo
//
//  Created by sorenu on 8/8/13.
//  Copyright (c) 2013 SHAPE. All rights reserved.
//

#import "ViewController.h"
#import "SHPCamera.h"

@interface ViewController ()
@property(nonatomic, strong) SHPCamera *camera;
@end

@interface ViewController ()

@end

@implementation ViewController {
    CGFloat _beginGestureScale;
}
- (void)viewDidLoad {
    [super viewDidLoad];

    _camera = [SHPCamera new];
    [_camera setImageQuality:SHPImageQualityHigh];

    // TODO
    // Lock to portrait
    //...

    // TODO
    // Disable tap to focus and remove focus view
    //...
    //...

    // TODO
    // Preview in full screen
    //...

    [_camera start];

    [self initPinchGestureRecognizer];
    [self initCaptureButton];
}

- (void)initCaptureButton {
    UIButton *captureButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [captureButton setTitle:@"Capture" forState:UIControlStateNormal];
    [captureButton addTarget:self action:@selector(captureImage:) forControlEvents:UIControlEventTouchUpInside];
    captureButton.frame = CGRectMake(10, 10, 100, 44);
    [self.view addSubview:captureButton];
}

- (void)captureImage:(id)sender {
    // TODO
    // Capture image and save to camera roll
    //...
}


- (IBAction)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
    BOOL allTouchesAreOnThePreviewLayer = YES;
    NSUInteger numTouches = [recognizer numberOfTouches], i;
    for ( i = 0; i < numTouches; ++i ) {
        CGPoint location = [recognizer locationOfTouch:i inView:_camera.previewView];
        CGPoint convertedLocation = [_camera.previewView.previewLayer convertPoint:location fromLayer:_camera.previewView.previewLayer.superlayer];
        if (![_camera.previewView.previewLayer containsPoint:convertedLocation] ) {
            allTouchesAreOnThePreviewLayer = NO;
            break;
        }
    }

    if ( allTouchesAreOnThePreviewLayer ) {

        //TODO: use the values you have available here to zoom the camera
        // Hint 1: _beginGestureScale
        // Hint 2: recognizer.scale
        //...
    }
}










- (void)initPinchGestureRecognizer {
    UIPinchGestureRecognizer *pinchGestureRecognizer = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];
    pinchGestureRecognizer.delegate = self;
    [self.view addGestureRecognizer:pinchGestureRecognizer];
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    if ([gestureRecognizer isKindOfClass:[UIPinchGestureRecognizer class]]) {
        _beginGestureScale = [_camera zoomScale];
    }
    return YES;
}

- (BOOL)shouldAutorotate {
    return NO;
}



@end