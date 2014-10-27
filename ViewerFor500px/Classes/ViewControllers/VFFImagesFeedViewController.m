//
//  VFFImagesFeedViewController.m
//  ViewerFor500px
//
//  Created by Dmitriy L on 10/3/14.
//  Copyright (c) 2014 Injectios. All rights reserved.
//

#import <CoreData/CoreData.h>
#import <CoreData+MagicalRecord.h>

#import "VFFImagesFeedViewController.h"
#import "VFFImageDetailsViewController.h"
#import "VFFPinchPresentInteractionController.h"
#import "VFFPinchPresentAnimationController.h"
#import "VFFPinchDismissInteractionController.h"
#import "VFFPinchDismissAnimationController.h"
#import "VFFImageFeedCell.h"
#import "VFFImage.h"
#import "VFFImagesManager.h"
#import "MBProgressHUD.h"

static NSString *cellIdentifier = @"VFFImageFeedIdentifier";

@interface VFFImagesFeedViewController ()
<
    NSFetchedResultsControllerDelegate,
    UIViewControllerTransitioningDelegate,
    UISearchBarDelegate,
    VFFImageDetailsViewControllerDataSource
>
{
    VFFPinchPresentInteractionController *_pinchPresentInteractionController;
    VFFPinchPresentAnimationController *_pinchPresentAnimationController;
    VFFPinchDismissInteractionController *_pinchDismissInteractionController;
    VFFPinchDismissAnimationController *_pinchDismissAnimationController;
}

@property (weak, nonatomic) IBOutlet UICollectionView *imagesFeed;
@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, assign) BOOL shouldReloadCollectionView;
@property (nonatomic, strong) NSMutableArray *photoChanges;
@end

@implementation VFFImagesFeedViewController

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    
    if (self) {
        _photoChanges = [NSMutableArray array];
        _pinchPresentInteractionController = [VFFPinchPresentInteractionController new];
        _pinchPresentAnimationController = [VFFPinchPresentAnimationController new];
        _pinchDismissInteractionController = [VFFPinchDismissInteractionController new];
        _pinchDismissAnimationController = [VFFPinchDismissAnimationController new];
    }
    
    return self;
}

- (void)viewDidLoad {
   [super viewDidLoad];

    [[VFFImagesManager sharedManager] loadFirstPage];
    NSError *error;
    if (![[self fetchedResultsController] performFetch:&error]) {
        // Update to handle the error appropriately.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        exit(-1);  // Fail
    }
    
    if (self.fetchedResultsController.fetchedObjects.count == 0) {
        [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"ShowDetails"]) {
        VFFImageDetailsViewController *imageDetailVC = segue.destinationViewController;
        imageDetailVC.transitioningDelegate = self;
        [_pinchDismissInteractionController wireToVC:imageDetailVC];
        
        if ([sender isKindOfClass:[VFFImage class]]) {
            imageDetailVC.image = (VFFImage *)sender;
            imageDetailVC.dataSource = self;
        }
    }
}

#pragma mark - Properties

- (NSFetchedResultsController *)fetchedResultsController {
    if (!_fetchedResultsController) {
        NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Image"];
        
        NSSortDescriptor *sort = [[NSSortDescriptor alloc]
                                  initWithKey:@"name" ascending:NO];
        [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
        _fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest managedObjectContext:[NSManagedObjectContext MR_defaultContext] sectionNameKeyPath:nil cacheName:nil];
        _fetchedResultsController.delegate = self;
    }
    return _fetchedResultsController;
}

#pragma mark - UICollectionViewDatasource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fetchedResultsController.fetchedObjects.count;
}

#pragma mark - UICollectionViewDelegate

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    VFFImageFeedCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    cell.photo = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    
    [_pinchPresentInteractionController preparePinchGesture:cell vc:self];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    VFFImage *image = [self.fetchedResultsController.fetchedObjects objectAtIndex:indexPath.row];
    [self performSegueWithIdentifier:@"ShowDetails" sender:image];
}

- (CGSize)collectionView:(UICollectionView *)collectionView
                  layout:(UICollectionViewLayout *)collectionViewLayout
  sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [self cellSizeForTraitCollection:self.traitCollection];
}

- (CGSize)cellSizeForTraitCollection:(UITraitCollection *)traitCollection {
    CGFloat size = 0.0f;
    
    if (traitCollection.verticalSizeClass == UIUserInterfaceSizeClassRegular)
        if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact)
            if (traitCollection.displayScale == 3.0)
                size = 125.0f;
            else
                size = ([[UIScreen mainScreen] bounds].size.height == 667.0f) ? 105.0f : 145.0f;
        else
            size = 240.0f;
    else
        if (traitCollection.horizontalSizeClass == UIUserInterfaceSizeClassCompact)
            size = ([[UIScreen mainScreen] bounds].size.width == 568.0f) ? 175.0f : 145.0f;
        else
            size = (traitCollection.displayScale == 3.0) ? 165.0f : 200.0f;
    
    return CGSizeMake(size, size);
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    [self.imagesFeed.collectionViewLayout invalidateLayout];
}

#pragma mark - Transition delegate methods

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source {
    return _pinchPresentAnimationController;
}

- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed {
    return _pinchDismissAnimationController;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForPresentation:(id<UIViewControllerAnimatedTransitioning>)animator {
    
    return _pinchPresentInteractionController.interactionInProgress ? _pinchPresentInteractionController : nil;
}

- (id<UIViewControllerInteractiveTransitioning>)interactionControllerForDismissal:(id<UIViewControllerAnimatedTransitioning>)animator {
    return _pinchDismissInteractionController.interactionInProgress ? _pinchDismissInteractionController : nil;
}

#pragma mark - UISearchBar delegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self filterContentForSearchText:searchText];
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self filterContentForSearchText:searchBar.text];
    [searchBar resignFirstResponder];
}

- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar {
    _fetchedResultsController = nil;
    
    NSError *error = nil;
    if (![self.fetchedResultsController performFetch:&error]) {
        exit(-1);
    }
    
    [self.imagesFeed reloadData];
    [searchBar resignFirstResponder];
}

- (void)filterContentForSearchText:(NSString*)searchText
{
    NSString *query = searchText;
    if (query && query.length) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"name contains[cd] %@", query];
        [_fetchedResultsController.fetchRequest setPredicate:predicate];
    }
    
    NSError *error = nil;
    if (![_fetchedResultsController performFetch:&error]) {
        exit(-1);
    }
    
    [self.imagesFeed reloadData];
}

#pragma mark - VFFImageDetailsViewControllerDataSource

- (NSUInteger)currentIndexForImage:(VFFImage *)image {
    __block NSUInteger currentIndex;
    [self.fetchedResultsController.fetchedObjects enumerateObjectsUsingBlock:^(id object, NSUInteger index, BOOL *stop) {
        if ([image isEqual:object]) {
            currentIndex = index;
            *stop = YES;            
        }
    }];
    return currentIndex;
}

- (VFFImage *)nextImageForImage:(VFFImage *)image
{
    NSUInteger currentImageIndex = [self currentIndexForImage:image];
    NSUInteger nextIndex = (self.fetchedResultsController.fetchedObjects.count-1 > currentImageIndex) ? currentImageIndex+1 : 0;
    return self.fetchedResultsController.fetchedObjects[nextIndex];
}

- (VFFImage *)previousImageForImage:(VFFImage *)image
{
    NSUInteger currentImageIndex = [self currentIndexForImage:image];
    NSUInteger previousIndex = (currentImageIndex != 0) ? currentImageIndex-1 : self.fetchedResultsController.fetchedObjects.count-1;
    return self.fetchedResultsController.fetchedObjects[previousIndex];
}

#pragma mark - NSFetchedResultController

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    
    NSMutableDictionary *change = [NSMutableDictionary new];
    switch(type)
    {
        case NSFetchedResultsChangeInsert:
            change[@(type)] = newIndexPath;
            break;
        case NSFetchedResultsChangeDelete:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeUpdate:
            change[@(type)] = indexPath;
            break;
        case NSFetchedResultsChangeMove:
            change[@(type)] = @[indexPath, newIndexPath];
            break;
    }
    [_photoChanges addObject:change];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    if ([_photoChanges count] > 0)
    {
        [self.imagesFeed performBatchUpdates:^{
            for (NSDictionary *change in _photoChanges)
            {
                [change enumerateKeysAndObjectsUsingBlock:^(NSNumber *key, id obj, BOOL *stop) {
                    NSFetchedResultsChangeType type = [key unsignedIntegerValue];
                    switch (type)
                    {
                        case NSFetchedResultsChangeInsert:
                            [self.imagesFeed insertItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeDelete:
                            [self.imagesFeed deleteItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeUpdate:
                            [self.imagesFeed reloadItemsAtIndexPaths:@[obj]];
                            break;
                        case NSFetchedResultsChangeMove:
                            [self.imagesFeed moveItemAtIndexPath:obj[0] toIndexPath:obj[1]];
                            break;
                    }
                }];
            }
        } completion:^(BOOL finished) {
            [MBProgressHUD hideAllHUDsForView:self.view animated:YES];
        }];
    }
    
    [_photoChanges removeAllObjects];
}

- (BOOL)shouldReloadCollectionViewToPreventKnownIssue {
    __block BOOL shouldReload = NO;
    for (NSDictionary *change in self.photoChanges) {
        [change enumerateKeysAndObjectsUsingBlock:^(id key, id obj, BOOL *stop) {
            NSFetchedResultsChangeType type = [key unsignedIntegerValue];
            NSIndexPath *indexPath = obj;
            switch (type) {
                case NSFetchedResultsChangeInsert:
                    shouldReload = YES;
                case NSFetchedResultsChangeDelete:
                    if ([self.imagesFeed numberOfItemsInSection:indexPath.section] == 1) {
                        shouldReload = YES;
                    } else {
                        shouldReload = NO;
                    }
                    break;
                case NSFetchedResultsChangeUpdate:
                    shouldReload = NO;
                    break;
                case NSFetchedResultsChangeMove:
                    shouldReload = NO;
                    break;
            }
        }];
    }
    return shouldReload;
}

@end
