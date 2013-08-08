//
// Created by sorenu on 8/8/13.
// Copyright (c) 2013 SHAPE. All rights reserved.
//
// To change the template use AppCode | Preferences | File Templates.
//


#import "Solution.h"
#import "SHPCamera.h"


@interface Solution () <UIGestureRecognizerDelegate>
@end

@implementation Solution {
    CGFloat _beginGestureScale;
    SHPCamera *_camera;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    _camera = [SHPCamera new];
    [_camera setImageQuality:SHPImageQualityHigh];

    // Lock to portrait
    [_camera setCameraOrientation:SHPCameraOrientationPortrait];

    // Disable tap to focus and remove focus view
    [_camera disableTapToFocus];
    _camera.previewView.focusView = nil;

    [_camera previewInView:self.view];
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
    [_camera captureJpegWithCompletion:^(NSData *imageData) {

    } saveToCameraRoll:YES saveCompletion:^(BOOL success) {
        if (success)
            NSLog(@"Image saved to camera roll");
        else
            NSLog(@"Error saving image");
    }];
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

        [_camera setZoomScale:_beginGestureScale * recognizer.scale];
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