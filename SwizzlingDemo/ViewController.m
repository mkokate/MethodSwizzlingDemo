//
//  ViewController.m
//  SwizzlingDemo
//
//  Created by Mahesh Kokate on 25/06/16.
//  Copyright © 2016 Mahesh Kokate. All rights reserved.
//

#import "ViewController.h"


@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [NSTimer scheduledTimerWithTimeInterval:10.0 target:self selector:@selector(TestChangedMethods) userInfo:nil repeats:NO];
}


- (void)TestChangedMethods
{
    [self firstMethod];
    [self secondMethod:@"demo"];
}

- (void)firstMethod
{
    NSLog(@"firstMethod");
}

- (void)secondMethod:(NSString *)strng1
{
    NSLog(@"secondMethod");
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

@end
