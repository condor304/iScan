//
//  ViewController.m
//  iScan
//
//  Created by Andrei Sandu on 05/10/15.
//  Copyright © 2015 Andrei Sandu. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Check the segue identifier
    if ([segue.identifier isEqualToString:@"toCameraSegue"])
    {
        // Get a reference to your custom view controller
        CameraViewController *customViewController = segue.destinationViewController;
        
        // Set your custom view controller's delegate
        customViewController.delegate = self;
    }
}


-(void)ProcessImage:(UIImage *)aImage{
    NSString *readData = [self processOCR:aImage];
   
    dispatch_async( dispatch_get_main_queue(), ^{
         _mTextView.text = readData;
        [_hud hide:true];
           });
   }

-(void)cameraDidFinishWith:(UIImage *)aImage{
    
   
    [self dismissViewControllerAnimated:YES completion:^{
       
        _hud = [MBProgressHUD showHUDAddedTo:self.view animated:YES];
        _hud.labelText = @"Procesing Image";
        _hud.mode = MBProgressHUDModeIndeterminate;
        dispatch_async( dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
           [self ProcessImage:aImage];
            
        });
    }];
}
-(NSString *)processOCR:(UIImage *)image
{
    G8Tesseract* tesseract = [[G8Tesseract alloc] initWithLanguage:@"eng"];
    tesseract.engineMode = G8OCREngineModeTesseractCubeCombined;
    tesseract.delegate = self;
    [tesseract setVariableValue:@"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789@_.(),-&/+<>" forKey:@"kG8ParamTesseditCharWhitelist"];
    tesseract.image =image;
    [tesseract recognize];
    
    return [tesseract recognizedText];
    
    tesseract = nil; //deallocate and free all memory
    
    // You could retrieve more information about recognized text with that methods:
    //    NSArray *characterBoxes = [tesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelSymbol];
    //    NSArray *paragraphs = [tesseract recognizedBlocksByIteratorLevel:G8PageIteratorLevelParagraph];
    //    NSArray *characterChoices = tesseract.characterChoices;
    //    UIImage *imageWithBlocks = [tesseract imageWithBlocks:characterBoxes drawText:YES thresholded:NO];
}



- (void)progressImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    NSLog(@"progress: %lu", (unsigned long)tesseract.progress);
}

- (BOOL)shouldCancelImageRecognitionForTesseract:(G8Tesseract *)tesseract {
    return NO;  // return YES, if you need to interrupt tesseract before it finishes
}



@end
