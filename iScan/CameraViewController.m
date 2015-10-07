//
//  CameraViewController.m
//  iScan
//
//  Created by Andrei Sandu on 05/10/15.
//  Copyright © 2015 Andrei Sandu. All rights reserved.
//

#import "CameraViewController.h"
#import "IPDFCameraViewController.h"

@interface CameraViewController ()

@property (weak, nonatomic) IBOutlet IPDFCameraViewController *cameraViewController;
- (IBAction)captureButton:(id)sender;

@property(assign) bool captured;

@end

@implementation CameraViewController

@synthesize delegate;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    
    [self.cameraViewController setupCameraView];
    [self.cameraViewController setEnableBorderDetection:YES];
    self.cameraViewController.cameraViewType = IPDFCameraViewTypeBlackAndWhite;
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [self.cameraViewController start];
    _captured = false;
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

#pragma mark -
#pragma mark CameraVC Capture Image

- (IBAction)captureButton:(id)sender
{
    if (_captured == false) {
        
        _captured = true;
        __weak typeof(self) weakSelf = self;
        
        [self.cameraViewController captureImageWithCompletionHander:^(NSString *imageFilePath)
         {
             
             
             UIImageView *captureImageView = [[UIImageView alloc] initWithImage:[UIImage imageWithContentsOfFile:imageFilePath]];
             _selImage = captureImageView.image;
             captureImageView.tag = 445;
             captureImageView.backgroundColor = [UIColor colorWithWhite:0.0 alpha:0.7];
             captureImageView.frame = CGRectOffset(weakSelf.view.bounds, 0, -weakSelf.view.bounds.size.height);
             captureImageView.alpha = 1.0;
             captureImageView.contentMode = UIViewContentModeScaleAspectFit;
             captureImageView.userInteractionEnabled = YES;
             [weakSelf.view addSubview:captureImageView];
             
             UIView *control = [[UIView alloc]initWithFrame:CGRectMake(0, weakSelf.view.bounds.size.height-60, weakSelf.view.bounds.size.width, 60)];
             control.tag = 444;
             control.backgroundColor = [UIColor whiteColor];
             
             UIButton *select = [UIButton buttonWithType:UIButtonTypeCustom];
             select.frame = CGRectMake(5, 5, 100, 50);
             [select setTitle:@"Use" forState:UIControlStateNormal];
             [select addTarget:self action:@selector(use) forControlEvents:UIControlEventTouchDown];
             [select setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             [control addSubview:select];
             
             
             UIButton *retake = [UIButton buttonWithType:UIButtonTypeCustom];
             retake.frame = CGRectMake(control.bounds.size.width-105, 5, 100, 50);
             [retake setTitle:@"Retake" forState:UIControlStateNormal];
             [retake addTarget:self action:@selector(dismissPreview) forControlEvents:UIControlEventTouchDown];
             [retake setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
             [control addSubview:retake];
             
             
             UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:weakSelf action:@selector(dismissPreview:)];
             [captureImageView addGestureRecognizer:dismissTap];
             
             [UIView animateWithDuration:0.5 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:0.7 options:UIViewAnimationOptionAllowUserInteraction animations:^
              {
                  captureImageView.frame = weakSelf.view.bounds;
                  [weakSelf.view addSubview:control];
                  
              } completion:nil];
         }];
        
    }
}


-(void)use{
    
    
    [self.delegate cameraDidFinishWith:_selImage];
}

-(void)dismissPreview{
    
    UIImageView *capture = (UIImageView*)[self.view viewWithTag:445];
    [capture removeFromSuperview];
    
    UIView *control = [self.view viewWithTag:444];
    [control removeFromSuperview];
    _captured = false;
}

- (void)dismissPreview:(UITapGestureRecognizer *)dismissTap
{
    [UIView animateWithDuration:0.7 delay:0.0 usingSpringWithDamping:0.8 initialSpringVelocity:1.0 options:UIViewAnimationOptionAllowUserInteraction animations:^
     {
         dismissTap.view.frame = CGRectOffset(self.view.bounds, 0, self.view.bounds.size.height);
     }
                     completion:^(BOOL finished)
     {
         [dismissTap.view removeFromSuperview];
         
         UIView *control = [  self.view viewWithTag:444];
         [control removeFromSuperview];
         _captured = false;
     }];
}

@end
