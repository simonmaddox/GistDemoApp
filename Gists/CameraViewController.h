//
//  CameraViewController.h
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol CameraDelegate <NSObject>
- (void)cameraFoundURL:(NSURL *)URL;
@end

@interface CameraViewController : UIViewController

@property (nonatomic, weak) id <CameraDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
