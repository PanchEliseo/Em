//
//  JSImagePickerViewController.m
//  iOS8Style-ImagePicker
//
//  Created by Jake Sieradzki on 09/01/2015.
//  Copyright (c) 2015 Jake Sieradzki. All rights reserved.
//

#import "JSImagePickerViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "UIImage+fixOrientation.h"

#pragma mark - JSImagePickerViewController -

@interface JSImagePickerViewController ()  <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

#define imagePickerHeight 280.0f

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

@property (readwrite) bool isVisible;

@property (nonatomic, strong) UIViewController *targetController;
@property (nonatomic, strong) UIWindow *window;

@property (nonatomic, strong) IBOutlet UIView *imagePickerView;
@property (nonatomic, weak) IBOutlet UIView * backgroundView;

@property (nonatomic) CGRect imagePickerFrame;
@property (nonatomic) CGRect hiddenFrame;

@property (nonatomic) TransitionDelegate *transitionController;

@property (nonatomic, strong) NSMutableArray *assets;

@end

@implementation JSImagePickerViewController

@synthesize delegate;
@synthesize transitionController;

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.assets = [[NSMutableArray alloc] init];
    [self setupView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if (self.showCamera && !self.view.hidden)
    {
        self.view.alpha = 0;
//        [self.cameraBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    if (self.showGallery && !self.view.hidden)
    {
        self.view.alpha = 0;
//        [self.photoLibraryBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
        
    }


}
- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.showCamera && !self.view.hidden)
    {
        self.view.hidden = YES;
        [self.cameraBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
    if (self.showGallery && !self.view.hidden)
    {
        self.view.hidden = YES;
        [self.photoLibraryBtn sendActionsForControlEvents:UIControlEventTouchUpInside];
    }
}

- (void)setupView
{
    self.view.backgroundColor = [UIColor colorWithWhite:0.1 alpha:0.7];
;
//    self.window = [UIApplication sharedApplication].keyWindow;
    
    self.imagePickerFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height-imagePickerHeight, [UIScreen mainScreen].bounds.size.width, imagePickerHeight);
    self.hiddenFrame = CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, imagePickerHeight);
    
    
    
//    self.backgroundView.alpha = 0;
    UITapGestureRecognizer *dismissTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
    self.backgroundView.userInteractionEnabled = YES;
    [self.backgroundView addGestureRecognizer:dismissTap];
//    UIImageView * imgVw = [[UIImageView alloc] initWithFrame:self.view.frame];
//    imgVw.image = [UIImage imageNamed:@"background_img"];
//    
//    [self.view addSubview:imgVw];
    self.animationTime = 0.2;
    
//    [self.window addSubview:self.backgroundView];
//    [self.window addSubview:self.imagePickerView];
    [self.view addSubview:self.imagePickerView];
    
//    UIButton *btn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.imagePickerView.frame.size.width, 50)];
//    [btn setTitle:@"Hello!" forState:UIControlStateNormal];
//    [btn setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
//    [btn addTarget:self action:@selector(setDefaults) forControlEvents:UIControlEventTouchUpInside];
//    
//    [self.imagePickerView addSubview:btn];

        [self imagePickerViewSetup];
        [self getCameraRollImages];
    
}

- (void)imagePickerViewSetup {



    [self.collectionView setBackgroundColor:[UIColor whiteColor]];
    self.collectionView.showsHorizontalScrollIndicator = NO;
    self.collectionView.showsVerticalScrollIndicator = NO;
    self.collectionView.delegate = self;
    self.collectionView.dataSource = self;
    [self.collectionView registerClass:[JSPhotoCell class] forCellWithReuseIdentifier:@"Cell"];
    
    UIFont *btnFont = [UIFont systemFontOfSize:19.0];
    
    [self.photoLibraryBtn setTitle:@"Fototeca" forState:UIControlStateNormal];
    self.photoLibraryBtn.titleLabel.font = btnFont;
    [self.photoLibraryBtn addTarget:self action:@selector(selectFromLibraryWasPressed) forControlEvents:UIControlEventTouchUpInside];
    

    [self.cameraBtn setTitle:@"Cámara" forState:UIControlStateNormal];
    self.cameraBtn.titleLabel.font = btnFont;
    [self.cameraBtn addTarget:self action:@selector(takePhotoWasPressed) forControlEvents:UIControlEventTouchUpInside];
    

    [self.cancelBtn setTitle:@"Cancelar" forState:UIControlStateNormal];
    self.cancelBtn.titleLabel.font = btnFont;
    [self.cancelBtn addTarget:self action:@selector(dismiss) forControlEvents:UIControlEventTouchUpInside];
    
    for (UIButton *btn in @[self.photoLibraryBtn, self.cameraBtn, self.cancelBtn])
    {
        [btn setTitleColor:UIColorFromRGB(0x0b60fe) forState:UIControlStateNormal];
        [btn setTitleColor:UIColorFromRGB(0x70B3FD) forState:UIControlStateHighlighted];
    }
}

#pragma mark - Collection view

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return MIN(20, self.assets.count);
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    JSPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    ALAsset *asset = self.assets[self.assets.count-1 - indexPath.row];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageWithCGImage:[asset thumbnail]]];
    imageView.clipsToBounds = YES;
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    [cell addSubview:imageView];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    [collectionView deselectItemAtIndexPath:indexPath animated:YES];
    
    ALAsset *asset = self.assets[self.assets.count-1 - indexPath.row];
    UIImage *image = [UIImage imageWithCGImage:[[asset defaultRepresentation] fullResolutionImage]];
    if ([delegate respondsToSelector:@selector(imagePickerDidSelectImage:)]) {
        [delegate imagePickerDidSelectImage:image];
    }
    
    [self dismissAnimated:YES];
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(170, 114);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 10.0f;
}

#pragma mark - Image library


- (void)getCameraRollImages {
    _assets = [@[] mutableCopy];
    __block NSMutableArray *tmpAssets = [@[] mutableCopy];
    ALAssetsLibrary *assetsLibrary = [JSImagePickerViewController defaultAssetsLibrary];
    [assetsLibrary enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos usingBlock:^(ALAssetsGroup *group, BOOL *stop) {
        [group enumerateAssetsUsingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if(result)
            {
                [tmpAssets addObject:result];
            }
        }];
        
        ALAssetsGroupEnumerationResultsBlock assetsEnumerationBlock = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result) {
                [self.assets addObject:result];
            }
        };
        
        ALAssetsFilter *onlyPhotosFilter = [ALAssetsFilter allPhotos];
        [group setAssetsFilter:onlyPhotosFilter];
        [group enumerateAssetsUsingBlock:assetsEnumerationBlock];
        
        [self.collectionView reloadData];
    } failureBlock:^(NSError *error) {
        NSLog(@"Error loading images %@", error);
    }];
}

+ (ALAssetsLibrary *)defaultAssetsLibrary
{
    static dispatch_once_t pred = 0;
    static ALAssetsLibrary *library = nil;
    dispatch_once(&pred, ^{
        library = [[ALAssetsLibrary alloc] init];
    });
    return library;
}

#pragma mark - Image picker

- (void)takePhotoWasPressed {
    if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        
        UIAlertView *myAlertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                              message:@"El dispositivo no cuenta con una cámara"
                                                             delegate:nil
                                                    cancelButtonTitle:@"OK"
                                                    otherButtonTitles: nil];
        
        [myAlertView show];
        
    } else {
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
        
        [self presentViewController:picker animated:YES completion:nil];
    }
}

- (void)selectFromLibraryWasPressed {
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    picker.delegate = self;
    picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    picker.mediaTypes = [[NSArray alloc] initWithObjects: (NSString *) kUTTypeImage, nil];
    
    [self presentViewController:picker animated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
    chosenImage = [chosenImage fixOrientation];
    if(chosenImage.size.width < chosenImage.size.height)
    {
        chosenImage = [chosenImage imageWithImage:chosenImage convertToSize:CGSizeMake(kEMDefaultWidthResizeImage, kEMDefaultHeightResizeImage)];

    }
    else
    {
        chosenImage = [chosenImage imageWithImage:chosenImage convertToSize:CGSizeMake(kEMDefaultHeightResizeImage, kEMDefaultWidthResizeImage)];
    }
    [picker dismissViewControllerAnimated:YES completion:^
    {
        if ([delegate respondsToSelector:@selector(imagePickerDidSelectImage:)]) {
            [delegate imagePickerDidSelectImage:chosenImage];
        }
            [self dismissAnimated:YES];

    }];

    
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{

    [picker dismissViewControllerAnimated:YES completion:^
    {
        if (self.showGallery || self.showCamera)
        {
            [self dismissAnimated:YES];
        }
        
    }];

}

#pragma mark - Show

- (void)showImagePickerInController:(UIViewController *)controller {
    [self showImagePickerInController:controller animated:YES];
}

- (void)showImagePickerInController:(UIViewController *)controller animated:(BOOL)animated {
    self.assets = [[NSMutableArray alloc] init];
    [self setupView];
    if (self.isVisible != YES) {
        if ([delegate respondsToSelector:@selector(imagePickerWillOpen)]) {
            [delegate imagePickerWillOpen];
        }
        self.isVisible = YES;
        
        [self setTransitioningDelegate:transitionController];
        self.modalPresentationStyle = UIModalPresentationCustom;
        [controller presentViewController:self animated:NO completion:nil];
        
        if (animated) {
            [UIView animateWithDuration:self.animationTime
                                  delay:0
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 [self.imagePickerView setFrame:self.imagePickerFrame];
                                 [self.view setAlpha:1];
                             }
                             completion:^(BOOL finished) {
                                 if ([delegate respondsToSelector:@selector(imagePickerDidOpen)]) {
                                     [delegate imagePickerDidOpen];
                                 }
                             }];
        } else {
            [self.imagePickerView setFrame:self.imagePickerFrame];
            [self.view setAlpha:0];
        }
    }
}

#pragma mark - Dismiss

- (void)dismiss {
    [self dismissAnimated:YES];
}

- (void)dismissAnimated:(BOOL)animated {
    if (self.isVisible == YES) {
        if ([delegate respondsToSelector:@selector(imagePickerWillClose)]) {
            [delegate imagePickerWillClose];
        }
        if (animated)
        {

            [UIView animateWithDuration:self.animationTime delay:0 options:UIViewAnimationOptionCurveEaseIn animations:^
            {
                self.view.alpha = 0;
            }
            completion:^(BOOL finished)
            {
                [UIView animateWithDuration:self.animationTime
                                      delay:0
                                    options:UIViewAnimationOptionCurveLinear
                                 animations:^{
                                     [self.view setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, self.view.frame.size.width, self.view.frame.size.height)];
                                     //                                 [self.backgroundView setAlpha:0];
                                 }
                                 completion:^(BOOL finished){
                                     [self.imagePickerView removeFromSuperview];
                                     //                                 [self.view removeFromSuperview];
                                     [self dismissViewControllerAnimated:NO completion:nil];
                                     if ([delegate respondsToSelector:@selector(imagePickerDidClose)]) {
                                         [delegate imagePickerDidClose];
                                     }
                                 }];

            }];
        }
        else
        {
            [self.imagePickerView setFrame:self.imagePickerFrame];
            [self.view setAlpha:0];
            [self.view removeFromSuperview];

        }
        
        // Set everything to nil
    }
}


#pragma -mark ScaleImage

@end



#pragma mark - TransitionDelegate -
@implementation TransitionDelegate

- (id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    AnimatedTransitioning *controller = [[AnimatedTransitioning alloc] init];
    controller.isPresenting = YES;
    return controller;
}

@end




#pragma mark - AnimatedTransitioning -
@implementation AnimatedTransitioning

- (NSTimeInterval)transitionDuration:(id <UIViewControllerContextTransitioning>)transitionContext {
    return 0.25f;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext {
    UIView *inView = [transitionContext containerView];
    UIViewController *toVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    UIViewController *fromVC = (UIViewController *)[transitionContext viewControllerForKey:UITransitionContextFromViewControllerKey];
    
    [inView addSubview:toVC.view];
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    [toVC.view setFrame:CGRectMake(0, screenRect.size.height, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
    
    [UIView animateWithDuration:0.25f
                     animations:^{
                         [toVC.view setFrame:CGRectMake(0, 0, fromVC.view.frame.size.width, fromVC.view.frame.size.height)];
                     }
                     completion:^(BOOL finished) {
                         [transitionContext completeTransition:YES];
                     }];
}



@end

#pragma mark - JSPhotoCell -
@interface JSPhotoCell ()

@end

@implementation JSPhotoCell

@end
