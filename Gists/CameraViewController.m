//
//  CameraViewController.m
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import "CameraViewController.h"
#import <AVFoundation/AVFoundation.h>
#import "Github.h"

@interface CameraViewController () <AVCaptureMetadataOutputObjectsDelegate>
@property (nonatomic, strong) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, strong) AVCaptureSession *session;
@end

@implementation CameraViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    AVCaptureDevice *camera = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:camera error:nil];
    
    self.session = [[AVCaptureSession alloc] init];
    [self.session addInput:input];
    
    AVCaptureMetadataOutput *captureMetadataOutput = [[AVCaptureMetadataOutput alloc] init];
    [self.session addOutput:captureMetadataOutput];
    [captureMetadataOutput setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [captureMetadataOutput setMetadataObjectTypes:@[AVMetadataObjectTypeQRCode]];
    
    self.previewLayer = [AVCaptureVideoPreviewLayer layerWithSession:self.session];
    self.previewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    
    [self.view.layer addSublayer:self.previewLayer];
    
    [self.session startRunning];
}

- (void)captureOutput:(AVCaptureOutput *)output didOutputMetadataObjects:(NSArray<__kindof AVMetadataObject *> *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    AVMetadataMachineReadableCodeObject *codeObject = [metadataObjects firstObject];
    NSString *foundURLString = [codeObject stringValue];

    if ([Github gistIDFromURLString:foundURLString]){
        NSURL *foundURL = [NSURL URLWithString:foundURLString];
        [self.delegate cameraFoundURL:foundURL];
        [self.session stopRunning];
        [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)viewDidLayoutSubviews
{
    [super viewDidLayoutSubviews];
    self.previewLayer.frame = self.view.bounds;
}

- (IBAction)cancelPressed:(id)sender
{
    [self.session stopRunning];
    [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

@end
