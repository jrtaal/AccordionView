//
//  AccordionViewController.h
//  Vidacle
//
//  Created by Jacco Taal on 18-02-13.
//  Copyright (c) 2013 Jacco Taal. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAccordionView.h"

@interface AccordionViewController : UIViewController <AccordionViewDelegate>

@property MyAccordionView * accordionView;
@property (strong, atomic) NSArray * viewControllers;

@end
