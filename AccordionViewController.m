//
//  AccordionViewController.m
//  Vidacle
//
//  Created by Jacco Taal on 18-02-13.
//  Copyright (c) 2013 Jacco Taal. All rights reserved.
//

#import "AccordionViewController.h"

    //#import <UIGlossyButton.h>
#import <QuartzCore/QuartzCore.h>

#import "LSAccordionButton.h"
#import "LSButton.h"

#define kAccordionButtonHeight 40.0


@interface AccordionViewController () {
    NSArray __strong * _myViewControllers;
}

@end

@implementation AccordionViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if ( [self.view class] != [MyAccordionView class])
        self.view = (UIView*) [[MyAccordionView alloc] initWithFrame:self.view.frame];
    self.accordionView = (MyAccordionView *)self.view;
    self.accordionView.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)shouldAutorotate {
    return false;
}

-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
    return UIInterfaceOrientationPortrait;
}

- (NSArray *)viewControllers {
    return self->_myViewControllers;
}

- (void)setViewControllers:(NSArray *)viewControllers {
    NSArray * oldVCs = self->_myViewControllers;
    self->_myViewControllers = [[NSArray alloc] initWithArray: viewControllers];

    [oldVCs enumerateObjectsUsingBlock:^(UIViewController * child, NSUInteger idx, BOOL *stop) {
        if ([viewControllers indexOfObject:child] == NSNotFound) {
            
            if ( [self.childViewControllers indexOfObject:child] != NSNotFound) {
                [child removeFromParentViewController];
            }
        }
        //if ([oldVCs indexOfObject:child] != NSNotFound)
        [self.accordionView removeSectionWithView: child.view ];
    }];
    NSUInteger N = viewControllers.count;

    //NSLog(@"accordionview bounds %@", NSStringFromCGRect(self.accordionView.bounds));
    [viewControllers enumerateObjectsUsingBlock:^(UIViewController * vc, NSUInteger idx, BOOL *stop) {
        //UIButton *header = [UIButton buttonWithType:UIButtonTypeCustom ];
        //header.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.3];
        
        //LSAccordionButton *header = [LSAccordionButton buttonWithType:UIButtonTypeCustom ];
        LSButton *header = [LSButton buttonWithType:UIButtonTypeCustom ];
            //header.buttonCornerRadius = 0;
            //header.buttonBorderWidth =0.0;
        //header.layer.borderColor = [UIColor colorWithWhite:0.3 alpha:1.0].CGColor;
        header.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds) , kAccordionButtonHeight);
        [header setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [header setTitle:(vc.tabBarItem.title ? vc.tabBarItem.title : vc.title) forState:UIControlStateNormal];
        //header.tintColor = [UIColor colorWithRed:0.2 green:0.2 blue:0.2 alpha:0.2];
        
        vc.view.bounds = CGRectMake(0, 0, CGRectGetWidth(self.view.bounds), //vc.view.bounds.size.width,
                                      self.accordionView.bounds.size.height-N*kAccordionButtonHeight);
        //NSLog(@"subview %d bounds %@", idx, NSStringFromCGRect(vc.view.bounds));
        [self.accordionView addHeader:header withView:vc.view];
    }];
    if (viewControllers.count>0)
        [self addChildViewController: viewControllers[0]];
    
    [self.accordionView setNeedsLayout];
    [self.accordionView setAllowsMultipleSelection:NO];
}


#pragma AccordionViewDelegate
- (void)accordion:(MyAccordionView *)accordion willChangeFromSelection:(NSIndexSet *)fromSelection toSelection:(NSIndexSet *)toSelection {
    //NSLog(@"Index: %@ -> %@", fromSelection, toSelection);
    for ( int i=0; i<self.viewControllers.count; i++) {
        if ( [toSelection containsIndex:i] && ! [fromSelection containsIndex:i]) {
            [self addChildViewController: self.viewControllers[i]];
            [self.viewControllers[i] beginAppearanceTransition:true animated:true];
        };
        if ( ![toSelection containsIndex:i] && [fromSelection containsIndex:i]) {
           [self.viewControllers[i]  willMoveToParentViewController:nil];
            [self.viewControllers[i] beginAppearanceTransition:false animated:true];
        }
    }
    
}
- (void)accordion:(MyAccordionView *)accordion didChangeFromSelection:(NSIndexSet *)fromSelection toSelection:(NSIndexSet *)toSelection {
    //NSLog(@"Index: %@ -> %@", fromSelection, toSelection);
    for ( int i=0; i<self.viewControllers.count; i++) {
        if ( [toSelection containsIndex:i] && ! [fromSelection containsIndex:i]) {
            [self.viewControllers[i] endAppearanceTransition];
            [self.viewControllers[i] didMoveToParentViewController:self];
        };
        if ( ![toSelection containsIndex:i] && [fromSelection containsIndex:i]) {
            if ( ((UIViewController*) self.viewControllers[i]).parentViewController)
                [self.viewControllers[i] endAppearanceTransition];
                [self.viewControllers[i] removeFromParentViewController];
        }
    }
}

@end
