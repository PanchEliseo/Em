//
//  EMGalleryCapacitacionesViewController.m
//  emetrix
//
//  Created by Carlos molina on 26/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMGalleryCapacitacionesViewController.h"
#import "EMGalleryCapacitacionesCollectionViewCell.h"
#import "IGLDropDownItem.h"
#import "IGLDropDownMenu.h"
#import "EMFiltersCapacitacionesViewController.h"
#import "UIViewController+STViewControllerExtension.h"
#import "EMContainerViewController.h"
#import <UIImageView+WebCache.h>
#import "EMCapacitacionesWebViewViewController.h"
#import <MWPhotoBrowser.h>

@interface EMGalleryCapacitacionesViewController ()<UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, MWPhotoBrowserDelegate, EMFiltersCapacitacionesDelegate>

@property (nonatomic, strong) EMFiltersCapacitacionesViewController * filtersVC;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (nonatomic) CGFloat boundaryPointY;
@property (nonatomic) CGFloat heigthFilter;
@property (strong, nonatomic) NSMutableArray * arrayCapacitaciones;
@property (strong, nonatomic) EMCategoriaCapacitacion * categoriaSelected;
@property (strong, nonatomic) MWPhotoBrowser * photoBrowser;
@property (strong, nonatomic) NSMutableArray * photos;



@end

@implementation EMGalleryCapacitacionesViewController

- (EMFiltersCapacitacionesViewController *)filtersVC
{
    if (!_filtersVC)
    {
        self.filtersVC = [self.storyboard instantiateViewControllerWithIdentifier:kEMStoryBoardFiltersCapacitaciones];
        if (([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeLeft || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationLandscapeRight) && UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
        {
            self.heigthFilter = CGRectGetHeight(self.view.frame) - 44;
            self.filtersVC.view.frame = CGRectMake(0, - self.heigthFilter  + 48 + 44, CGRectGetWidth(self.view.frame) , self.heigthFilter);
        }
        else
        {
            self.heigthFilter = CGRectGetHeight(self.view.frame) - 64;
            self.filtersVC.view.frame = CGRectMake(0, - self.heigthFilter  + 48 + 64, CGRectGetWidth(self.view.frame) , self.heigthFilter);
        }
        
        
        [self.view addSubview:self.filtersVC.view];
        self.filtersVC.delegate = self;
    }
    return _filtersVC;
}

- (MWPhotoBrowser *)photoBrowser
{
    
    _photoBrowser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    _photoBrowser.displayActionButton = YES; // Show action button to allow sharing, copying, etc (defaults to YES)
    _photoBrowser.displayNavArrows = NO; // Whether to display left and right nav arrows on toolbar (defaults to NO)
    _photoBrowser.displaySelectionButtons = NO; // Whether selection buttons are shown on each image (defaults to NO)
    _photoBrowser.zoomPhotosToFill = YES; // Images that almost fill the screen will be initially zoomed to fill (defaults to YES)
    _photoBrowser.alwaysShowControls = NO; // Allows to control whether the bars and controls are always visible or whether they fade away to show the photo full (defaults to NO)
    _photoBrowser.enableGrid = YES; // Whether to allow the viewing of all the photo thumbnails on a grid (defaults to YES)
    _photoBrowser.startOnGrid = NO; // Whether to start on the grid of thumbnails instead of the first photo (defaults to NO)
    _photoBrowser.autoPlayOnAppear = NO; // Auto-play first video
    [_photoBrowser setCurrentPhotoIndex:0];
    return _photoBrowser;
}

- (NSMutableArray *)arrayCapacitaciones
{
    _arrayCapacitaciones = [[EMManagedObject sharedInstance] mutableArrayCapacitacionesForCategoria:_categoriaSelected forCuenta:[self containerParentViewController].cuenta];
    return _arrayCapacitaciones;
}

- (void)setCategoriaSelected:(EMCategoriaCapacitacion *)categoriaSelected
{
    _categoriaSelected = categoriaSelected;
    [self.collectionView reloadData];
}


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    


    // Do any additional setup after loading the view.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.view bringSubviewToFront:self.filtersVC.view];
    [self.collectionView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma -mark UICollectionView

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayCapacitaciones.count;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    EMCapacitacion *capacitacion = [self.arrayCapacitaciones objectAtIndex:indexPath.row];
    EMGalleryCapacitacionesCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:kEMKeyCellGalleryCapacitaciones forIndexPath:indexPath];
    [cell.imgVwThumb sd_setImageWithURL:[NSURL URLWithString:capacitacion.urlThumb] placeholderImage:[UIImage imageNamed:@"emetrix_logo_login"]];
    cell.lbfComment.text = capacitacion.comentario;
    [cell.contentView bringSubviewToFront:cell.vwLbf];
    if (capacitacion.comentario.length)
    {
        cell.vwLbf.hidden = NO;
    }
    else
    {
        cell.vwLbf.hidden = YES;
    }
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    EMCapacitacion *capacitacion = [self.arrayCapacitaciones objectAtIndex:indexPath.row];
    if ([capacitacion.urlArchivo rangeOfString:@"jpg"].location != NSNotFound || [capacitacion.urlArchivo rangeOfString:@"jpeg"].location != NSNotFound || [capacitacion.urlArchivo rangeOfString:@"png"].location != NSNotFound)
    {
        self.photos = [NSMutableArray arrayWithObject:[MWPhoto photoWithURL:[NSURL URLWithString:capacitacion.urlArchivo]]];
        [self.navigationController pushViewController:self.photoBrowser animated:YES];

    }
    else if([capacitacion.urlArchivo rangeOfString:@"mp4"].location != NSNotFound)
    {
        self.photos = [NSMutableArray arrayWithObject:[MWPhoto videoWithURL:[NSURL URLWithString:capacitacion.urlArchivo]]];
        [self.navigationController pushViewController:self.photoBrowser animated:YES];

    }
    else
    {
        [self performSegueWithIdentifier:kEMStoryBoardWebViewCapacitaciones sender:capacitacion];
    }
    
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width;
    if ([[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortrait || [[UIApplication sharedApplication] statusBarOrientation] == UIInterfaceOrientationPortraitUpsideDown)
    {
        width = (CGRectGetWidth(collectionView.frame) - (2 * 5)) / 2;
    }
    else
    {
        if (self.arrayCapacitaciones.count <= 4)
        {
            width = (CGRectGetWidth(collectionView.frame) - (self.arrayCapacitaciones.count * 5)) / self.arrayCapacitaciones.count;
        }
        else
        {
            width = [UIScreen mainScreen].bounds.size.height;
            width = [UIScreen mainScreen].bounds.size.width;
            width = (CGRectGetWidth(collectionView.frame) - (4 * 5)) / 4;
        }
        
    }
    return CGSizeMake(width, 240);
    
}

#pragma -mark EMFiltersCapacitacionesDelegate

- (void) filtersCapacitaciones:(EMFiltersCapacitacionesViewController *)filtersCapacitaciones didSelectFilterCategory:(EMCategoriaCapacitacion *)categoriaCapacitacion
{
    self.categoriaSelected = categoriaCapacitacion;
    [self.collectionView reloadData];
}

#pragma -mark Segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.identifier isEqualToString:kEMStoryBoardWebViewCapacitaciones])
    {
        ((EMCapacitacionesWebViewViewController *)segue.destinationViewController).urlRequest = [NSURL URLWithString:((EMCapacitacion *)sender).urlArchivo];
    }
}

#pragma -mark Rotate

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{

    self.filtersVC = nil;
    [self.view bringSubviewToFront:self.filtersVC.view];
    [self.collectionView reloadData];
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [self.filtersVC.view removeFromSuperview];
    [self.filtersVC removeFromParentViewController];
}
#pragma -mark MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser
{
    return self.photos.count;
}

- (id<MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index
{
    if (index < self.photos.count)
    {
        return [self.photos objectAtIndex:index];
    }
    return nil;
}

//- (NSUInteger) supportedInterfaceOrientations
//{
//    UITabBarController * tabBar = [[UITabBarController alloc] init];
//    if ([tabBar.selectedViewController isKindOfClass:[UINavigationController class]])
//    {
//        UINavigationController * navigation = (UINavigationController *)tabBar.selectedViewController;
//        if (navigation.visibleViewController isKindOfClass:[ModalClass class])
//        {
//            return UIInterfaceOrientationMaskLandscape;
//
//        }
//    }
//    return UIInterfaceOrientationMaskPortrait;
//
//}



/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation

*/

@end
