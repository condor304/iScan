//
//  ViewController.h
//  iScan
//
//  Created by Andrei Sandu on 05/10/15.
//  Copyright © 2015 Andrei Sandu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <TesseractOCR/TesseractOCR.h>
#import <MBProgressHUD/MBProgressHUD.h>
#import "CameraViewController.h"

@interface ViewController : UIViewController<G8TesseractDelegate,MyCameraDelegate>

@property MBProgressHUD *hud;
@property (weak, nonatomic) IBOutlet UITextView *mTextView;

@end

