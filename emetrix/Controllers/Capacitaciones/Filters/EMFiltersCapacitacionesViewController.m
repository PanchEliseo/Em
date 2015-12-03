//
//  EMFiltersCapacitacionesViewController.m
//  emetrix
//
//  Created by Carlos molina on 26/08/15.
//  Copyright (c) 2015 evolve. All rights reserved.
//

#import "EMFiltersCapacitacionesViewController.h"
#import "EMFiltersCapacitacionesTableViewCell.h"

@interface EMFiltersCapacitacionesViewController ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray * arrayCategoriasCapacitacion;
@property (weak, nonatomic) IBOutlet UIButton *btnCategory;
@property (weak, nonatomic) IBOutlet UIImageView *imgVwArrow;
@property (nonatomic, strong) UIDynamicAnimator *animator;
@end

@implementation EMFiltersCapacitacionesViewController

- (NSMutableArray *)arrayCategoriasCapacitacion
{
    _arrayCategoriasCapacitacion = [[EMManagedObject sharedInstance] mutableArrayCategoriaCapacitacion];
    return _arrayCategoriasCapacitacion;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.arrayCategoriasCapacitacion.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMFiltersCapacitacionesTableViewCell * cell = (EMFiltersCapacitacionesTableViewCell *)[tableView dequeueReusableCellWithIdentifier:kEMKeyCellFiltersCapacitaciones];
    EMCategoriaCapacitacion * categoria = [self.arrayCategoriasCapacitacion objectAtIndex:indexPath.row];
    cell.lbfTitle.text = categoria.categoria;
    return cell;

}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    EMCategoriaCapacitacion * categoria = [self.arrayCategoriasCapacitacion objectAtIndex:indexPath.row];
    if ([self.delegate respondsToSelector:@selector(filtersCapacitaciones:didSelectFilterCategory:)])
    {
        [self.delegate filtersCapacitaciones:self didSelectFilterCategory:categoria];
    }
    [self didPressSelectFilters:self.btnCategory];
    [self.btnCategory setTitle:[NSString stringWithFormat:@"Categoría: %@", categoria.categoria] forState:UIControlStateNormal];
    [self.btnCategory setTitle:[NSString stringWithFormat:@"Categoría: %@", categoria.categoria] forState:UIControlStateSelected];
}



- (void)toggleMenu:(BOOL)shouldOpenMenu{
    [self.animator removeAllBehaviors];
    self.animator = [[UIDynamicAnimator alloc] initWithReferenceView:self.view.superview];
    
    UIGravityBehavior* gravityBehavior =
    [[UIGravityBehavior alloc] initWithItems:@[self.view]];
    if (!shouldOpenMenu)
    {
        gravityBehavior.gravityDirection = CGVectorMake(0.0, -1.0);
    }
    gravityBehavior.magnitude = 5.0;
    [self.animator addBehavior:gravityBehavior];
    

    UICollisionBehavior* collisionBehavior =
    [[UICollisionBehavior alloc] initWithItems:@[self.view]];
    if (shouldOpenMenu)
    {
        [collisionBehavior addBoundaryWithIdentifier:@"View" fromPoint:CGPointMake(0, CGRectGetHeight(self.view.frame) + 64) toPoint:CGPointMake(CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame) + 64)];
    }
    else
    {
       [collisionBehavior addBoundaryWithIdentifier:@"View" fromPoint:CGPointMake(0, - CGRectGetHeight(self.view.frame) + 64 + 48) toPoint:CGPointMake(CGRectGetWidth(self.view.frame), - CGRectGetHeight(self.view.frame) + 64 + 48)];
    }

//    collisionBehavior.translatesReferenceBoundsIntoBoundary = YES;
    [self.animator addBehavior:collisionBehavior];
    
    UIDynamicItemBehavior *elasticityBehavior =
    [[UIDynamicItemBehavior alloc] initWithItems:@[self.view]];
    elasticityBehavior.elasticity = 0.4f;
    [self.animator addBehavior:elasticityBehavior];
    
}

- (IBAction)didPressSelectFilters:(UIButton *)sender
{
    if (sender.selected)
    {
        [self toggleMenu:NO];
        sender.selected = NO;
        [UIView animateWithDuration:1.0 animations:^{
            self.imgVwArrow.transform = CGAffineTransformMakeRotation(0);
            
        }];
    }
    else
    {
        [self toggleMenu:YES];
        sender.selected = YES;
        [UIView animateWithDuration:1.0 animations:^{
            self.imgVwArrow.transform = CGAffineTransformMakeRotation(M_PI);
            
        }];
    }
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
