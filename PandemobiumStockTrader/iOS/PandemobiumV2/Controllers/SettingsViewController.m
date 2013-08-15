//
//  SettingsViewController.m
//  Pandemobium
//
//  Created by Thomas Salazar on 6/26/13.
//  Copyright (c) 2013 Thomas Salazar. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController

@synthesize sliderLabel;
@synthesize slider;


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(handleUpdatedData:)
                                                 name:@"outOfRange"
                                               object:nil];


    // Uncomment the following line to preserve selection between presentations.
     //self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
     //self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)forgotPassword:(id)sender {
    
    NSLog(@"forgotpassword button is pressed");
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/web/forgotpassword.jsp"];     //finish making the forgotpassword page
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:requestURL delegate:self startImmediately:YES];
    
    if(connection)
    {
        NSLog(@"connection is established");
        [[UIApplication sharedApplication] openURL:url];
    }else
    {
        NSLog(@"user connection failed to %@", url);
    }
}

- (IBAction)enableWalkthrough:(id)sender {
    
    NSLog(@"walkthrough button is pressed");
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/web/"];       //update with page that contains slides from powerpoint
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:requestURL delegate:self startImmediately:YES];
    
    if(connection)
    {
        NSLog(@"connection is established");
        [[UIApplication sharedApplication] openURL:url];
    }else
    {
        NSLog(@"user connection failed to %@", url);
    }
}

- (IBAction)aboutButton:(id)sender {
    
    NSLog(@"about button is pressed");
    NSURL *url = [NSURL URLWithString:@"http://localhost:8080/web/"];       //update with url that goes to the about pandemobium page 
    NSURLRequest *requestURL = [NSURLRequest requestWithURL:url];
    NSURLConnection * connection = [[NSURLConnection alloc] initWithRequest:requestURL delegate:self startImmediately:YES];
    
    if(connection)
    {
        NSLog(@"connection is established");
        [[UIApplication sharedApplication] openURL:url];
    }else
    {
        NSLog(@"user connection failed to %@", url);
    }
}

- (IBAction)sliderChanged:(id)sender
{
    self.slider = (UISlider *) sender;
    
    int progressAsInt = (int)(slider.value + 0.5f);
    
    NSString *newText = [[NSString alloc] initWithFormat:@"%d", progressAsInt];
    
    self.sliderLabel.text = newText;
    NSLog(@"%d", progressAsInt);
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
}

-(void)handleUpdatedData:(NSNotification *)notification {
    //  NSLog(@"recieved");
    [self viewDidLoad];
}

@end
