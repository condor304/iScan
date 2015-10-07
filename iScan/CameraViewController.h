//
//  CameraViewController.h
//  iScan
//
//  Created by Andrei Sandu on 05/10/15.
//  Copyright © 2015 Andrei Sandu. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol MyCameraDelegate <NSObject>
@optional
- (void)cameraDidFinishWith:(UIImage *)aImage;
// ... other methods here
@end


@interface CameraViewController : UIViewController


@property (nonatomic, weak) id <MyCameraDelegate> delegate;
@property(nonatomic, strong)UIImage *selImage;

@end



