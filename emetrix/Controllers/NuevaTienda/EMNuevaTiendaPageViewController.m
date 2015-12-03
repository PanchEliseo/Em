//
//  EMNuevaTiendaPageViewController.m
//  emetrix
//
//  Created by Marco on 18/11/15.
//  Copyright © 2015 evolve. All rights reserved.
//

#import "EMNuevaTiendaPageViewController.h"
#import "EMSondeoViewController.h"
#import "EMCommonViewController.h"
#import "EMListTiendaViewController.h"
#import "UIColor+EMColorExtension.h"

@interface EMNuevaTiendaPageViewController ()
{
    CGRect rect;
    NSMutableArray * viewControllers;
    UIPageViewController * nuevaTiendaPageViewController;
    
    IBOutlet UIBarButtonItem * btnEnviar;
}

@end

@implementation EMNuevaTiendaPageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor emDarkBlueColor];
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] init];
    self.navigationItem.leftBarButtonItem.style = UIBarButtonItemStylePlain;
    self.navigationItem.leftBarButtonItem.title = @"Ruta";
    self.navigationItem.leftBarButtonItem.target = self;
    self.navigationItem.leftBarButtonItem.action = @selector(performBack:);
    
    nuevaTiendaPageViewController = [[UIPageViewController alloc] initWithTransitionStyle:UIPageViewControllerTransitionStyleScroll navigationOrientation:UIPageViewControllerNavigationOrientationHorizontal options:nil];
    nuevaTiendaPageViewController.dataSource = self;
    nuevaTiendaPageViewController.delegate = self;
    
    [self viewControllerAtIndex:0];
    [nuevaTiendaPageViewController setViewControllers:viewControllers direction:UIPageViewControllerNavigationDirectionForward animated:YES completion:nil];
    
    rect = CGRectMake(self.view.bounds.origin.x,
                      self.view.bounds.origin.y + self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height,
                      self.view.bounds.size.width,
                      self.view.bounds.size.height - (self.navigationController.navigationBar.bounds.size.height + [UIApplication sharedApplication].statusBarFrame.size.height));
    
    [nuevaTiendaPageViewController.view setFrame:rect];
    
    [self addChildViewController:nuevaTiendaPageViewController];
    
    [self.view addSubview:nuevaTiendaPageViewController.view];
    
    [nuevaTiendaPageViewController didMoveToParentViewController:self];
    
    self.title = self.sondeo.nombre;
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    }
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




#pragma -mark PageViewController


-(void)pageViewController:(UIPageViewController *)pageViewController willTransitionToViewControllers:(NSArray<UIViewController *> *)pendingViewControllers
{
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:pageViewController.viewControllers];
    [intermediate removeObjectsInArray:pendingViewControllers];

    [self hideUnhideRightBarButtonItem:(EMCommonViewController *)intermediate.firstObject];
}

-(void)pageViewController:(UIPageViewController *)pageViewController didFinishAnimating:(BOOL)finished previousViewControllers:(NSArray<UIViewController *> *)previousViewControllers transitionCompleted:(BOOL)completed
{
    NSMutableArray *intermediate = [NSMutableArray arrayWithArray:pageViewController.viewControllers];
    [intermediate removeObjectsInArray:previousViewControllers];
    
    [self hideUnhideRightBarButtonItem:(EMCommonViewController *)intermediate.firstObject];
}


-(void)hideUnhideRightBarButtonItem:(EMCommonViewController *) viewController
{
    if (viewController) {
        if ([viewController isKindOfClass:[EMListTiendaViewController class]])
            self.navigationItem.rightBarButtonItem = nil;
        else
            self.navigationItem.rightBarButtonItem = btnEnviar;
    }
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerBeforeViewController:(UIViewController *)viewController {
    
    NSUInteger index = [[(EMCommonViewController *)viewController index] integerValue];

    if (index == 0)
        return nil;
    
    index--;
    
    return [self viewControllerAtIndex:index];
}


- (UIViewController *)pageViewController:(UIPageViewController *)pageViewController viewControllerAfterViewController:(UIViewController *)viewController {
    
    NSUInteger index = [[(EMCommonViewController *)viewController index] integerValue];
    
    index++;
    
    if (index == 2)
        return nil;
    
    return [self viewControllerAtIndex:index];
}


- (NSInteger)presentationCountForPageViewController:(UIPageViewController *)pageViewController {
    return 2;
}

- (NSInteger)presentationIndexForPageViewController:(UIPageViewController *)pageViewController {
    return 0;
}


- (EMCommonViewController *)viewControllerAtIndex:(NSUInteger)index {
    
    EMCommonViewController * childViewController;
    
    if (index < viewControllers.count)
        childViewController = (EMCommonViewController *)[viewControllers objectAtIndex:index];
    
    if (childViewController == nil) {
        if (index == 0) {
            UINavigationController * navigation = (UINavigationController *)[self viewControllerForStoryBoardName:@"Sondeo"];
            childViewController = [navigation.viewControllers objectAtIndex:0];
            ((EMSondeoViewController *)childViewController).sondeo = self.sondeo;
            ((EMSondeoViewController *)childViewController).cuenta = self.cuenta;
            ((EMSondeoViewController *)childViewController).tienda = self.tienda;
            ((EMSondeoViewController *)childViewController).usuario = self.usuario;
        }
        else if (index == 1) {
            UIStoryboard * storyBoard = [UIStoryboard storyboardWithName:@"NuevaTienda" bundle:nil];
            childViewController = [storyBoard instantiateViewControllerWithIdentifier:@"EMListTiendaViewController"];
            ((EMListTiendaViewController *)childViewController).usuario = self.usuario;
            ((EMListTiendaViewController *)childViewController).cuenta = self.cuenta;
        }
        
        if ([viewControllers containsObject:childViewController] == NO)
        {
            if (viewControllers == nil)
                viewControllers = [[NSMutableArray alloc] init];
                
            [viewControllers addObject:childViewController];
        }
        
        childViewController.index = [NSNumber numberWithUnsignedInteger:index];
        childViewController.view.frame = rect;
    }

    return childViewController;
}


- (UIViewController *) viewControllerForStoryBoardName:(NSString *) storyBoardName
{
    UIStoryboard * story = [UIStoryboard storyboardWithName:storyBoardName bundle:nil];
    return [story instantiateInitialViewController];
}


-(IBAction)didPressSent:(id)sender
{
    EMSondeoViewController * sondeosViewController = (EMSondeoViewController *)nuevaTiendaPageViewController.viewControllers.firstObject;
    [sondeosViewController didPressSend:sender];
}


-(void)performBack:(id)sender {
    
    if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    }
    
    [self.navigationController popViewControllerAnimated:YES];
}


@end
