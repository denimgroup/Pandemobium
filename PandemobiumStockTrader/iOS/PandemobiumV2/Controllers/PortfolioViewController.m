//
// Pandemobium Stock Trader is a mobile app for Android and iPhone with
// vulnerabilities included for security testing purposes.
// Copyright (c) 2013 Denim Group, Ltd. All rights reserved worldwide.
//
// This file is part of Pandemobium Stock Trader.
//
// Pandemobium Stock Trader is free software: you can redistribute it
// and/or modify it under the terms of the GNU General Public License
// as published by the Free Software Foundation; either version 3
// of the License, or (at your option) any later version.
//
// This program is distributed in the hope that it will be useful,
// but WITHOUT ANY WARRANTY; without even the implied warranty of
// MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the
// GNU General Public License for more details.
//
// You should have received a copy of the GNU General Public License
// along with Pandemobium Stock Trader. If not, see
// <http://www.gnu.org/licenses/>.

#import "PortfolioViewController.h"
#import "AppDelegate.h"
#import "DBHelper.h"
#import "CorePlot-CocoaTouch.h"


@interface PortfolioViewController ()

@end

@implementation PortfolioViewController

CGFloat const CPDBarWidth = 0.25f;
CGFloat const CPDBarInitialX = 0.5f;

@synthesize accntImage;
@synthesize barGraphImage;
@synthesize accountNumber;
@synthesize numberShares;
@synthesize netWorth;
@synthesize listOfStocks;
@synthesize hostView = hostView_;
@synthesize barHostView = barHostView_;
@synthesize stockValues;
@synthesize portfolioSum;
@synthesize shares;
@synthesize stockAnnotation = stockAnnotation_;
@synthesize activityIndicator;
@synthesize accountValue;

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    

    [self fetchData];
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    stockValues = [[NSArray alloc]init];
    portfolioSum = [NSDecimalNumber zero];
    
    // The plot is initialized here
    // since the view bounds have not transformed for landscaepe until now
    if(appDelegate.user.loggedIn.intValue == 1)
    {
        //stockValues = [helper getStockValue:appDelegate.user.accountID];
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SHARES > 0"];
        stockValues = [appDelegate.user.favoriteStocks filteredArrayUsingPredicate:pred];
        
        
        //stockValues = appDelegate.user.favoriteStocks;
        portfolioSum = [[NSDecimalNumber alloc]initWithDouble:[appDelegate.user.accountValue doubleValue]];
        
        [self initPlot];
        [self initBarPlot];
    }

}

-(void)viewDidAppear:(BOOL)animated
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    
    stockValues = [[NSArray alloc]init];
    portfolioSum = [NSDecimalNumber zero];
    
    [super viewDidAppear:animated];
    // The plot is initialized here
    // since the view bounds have not transformed for landscaepe until now
    if(appDelegate.user.loggedIn.intValue == 1)
    {
        NSPredicate *pred = [NSPredicate predicateWithFormat:@"SHARES > 0"];
        stockValues = [appDelegate.user.favoriteStocks filteredArrayUsingPredicate:pred];
        portfolioSum = [[NSDecimalNumber alloc]initWithDouble:[appDelegate.user.accountValue doubleValue]];
        
        [self initPlot];
        [self initBarPlot];
    }
}

-(void)fetchData
{
    AppDelegate *appDelegate = [UIApplication sharedApplication].delegate;
    NSDictionary *results;
    DBHelper * helper = [[DBHelper alloc]init];
    UIAlertView *alert;
    if(appDelegate.user.loggedIn.intValue == 1)
    {
        results = [helper getAccountInfo:appDelegate.user.accountID];
        accountNumber.text = [[NSString alloc] initWithFormat:@"%i", appDelegate.user.accountID.intValue];
        numberShares.text = [[NSString alloc]initWithFormat:@"%i", [appDelegate.user.totalShares intValue]];
        accountValue.text = [[NSString alloc]initWithFormat:@"$%0.2f", [appDelegate.user.accountValue doubleValue]];
        netWorth.text = [[NSString alloc]initWithFormat:@"$%0.2f", [[results valueForKey:@"BALANCE"]doubleValue] ];
        
    }
    else
    {
        accountNumber.text = @"xxxx";
        numberShares.text = @"0";
        netWorth.text = @"$0.00";
        accountValue.text=@"$0.00";
        accntImage.image = [UIImage imageNamed:@"burg.jpg"];

        alert = [[UIAlertView alloc] initWithTitle:@"Error!"
                                           message:@"Please log-in to see your 'Portfolio.'"
                                          delegate:nil
                                 cancelButtonTitle:@"OK"
                                 otherButtonTitles: nil];
        [alert show];

    }
    
}

-(BOOL)isLoggedIn
{
    AppDelegate * app = [UIApplication sharedApplication].delegate;
    if(app.user.loggedIn == [[NSNumber alloc]initWithInt:1])
    {
        return TRUE;
    }
    return FALSE;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)revealMenu:(id)sender
{
    [self.slidingViewController anchorTopViewTo:ECRight];
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

#pragma mark - CPTPlotDataSource methods


-(NSUInteger)numberOfRecordsForPlot:(CPTPlot *)plot
{
    return [stockValues count];
}

-(NSNumber *)numberForPlot:(CPTPlot *)plot field:(NSUInteger)fieldEnum recordIndex:(NSUInteger)index
{
   
    if([plot.identifier isEqual:@"Portfolio"])
    {
           
           if (CPTPieChartFieldSliceWidth == fieldEnum)
           {
               return [[stockValues objectAtIndex:index]valueForKey:@"value"];
            }
    }
    else if( [plot.identifier isEqual:@"barPlot"])
    {
        if(fieldEnum == CPTBarPlotFieldBarLocation)
            return [[NSNumber alloc]initWithInt:index];
        else if (fieldEnum == CPTBarPlotFieldBarTip)
            return [[stockValues objectAtIndex:index]valueForKey:@"SHARES"];
    }
    
    return [NSDecimalNumber zero];
}

-(CPTLayer *)dataLabelForPlot:(CPTPlot *)plot recordIndex:(NSUInteger)index
{
     // 1 - Define label text style
        static CPTMutableTextStyle *labelText = nil;
        if(!labelText)
        {
            labelText = [[CPTMutableTextStyle alloc] init];
            labelText.color = [CPTColor grayColor];
            labelText.fontSize = 12.0f;
        }
    
    NSString *labelValue;
    if([plot.identifier isEqual:@"Portfolio"])
    {
        //3 Calculate percentage value
        NSNumber *price = [[stockValues objectAtIndex:index]valueForKey:@"value"];
        
        //4 Set up display label
        //labelValue = [NSString stringWithFormat:@"$%0.2f USD (%0.1f %%)", [price doubleValue], ([percent doubleValue] * 100.0f)];
        labelValue = [NSString stringWithFormat:@"$%0.2f", [price doubleValue]];
        
        
    }
    else
    {
        labelText.color = [CPTColor whiteColor];
        labelText.fontSize = 12.0f;
        
        labelValue = [NSString stringWithFormat:@"%@: %i", [[stockValues objectAtIndex:index] valueForKey:@"SYMBOL"],
                      [[[stockValues objectAtIndex:index]valueForKey:@"SHARES"]intValue]];
    }
    return [[CPTTextLayer alloc] initWithText:labelValue style:labelText];
    
}


-(NSString *)legendTitleForPieChart:(CPTPieChart *)pieChart recordIndex:(NSUInteger)index
{
    if(index < [stockValues count])
    {
        return [[stockValues objectAtIndex:index] valueForKey:@"SYMBOL"];
    }
    return @"N/A";
}

#pragma mark - Chart behavior
-(void)initPlot {
    [self configureHost];
    [self configureGraph];
    [self configureChart];
    [self configureLegend];
}

-(void)configureHost {
    
    
    // 1 - Set up view fram
    CGRect parentRect = self.accntImage.bounds;
    parentRect = CGRectMake(parentRect.origin.x, (parentRect.origin.y ), parentRect.size.width, (parentRect.size.height ));
    
    // 2 - Creat host view
    self.hostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc] initWithFrame:parentRect];
    self.hostView.allowPinchScaling = NO;
    [self.accntImage addSubview:self.hostView];
    
    
    //3 - Set up Bar Graph Plot
    parentRect = self.barGraphImage.bounds;
    parentRect = CGRectMake(parentRect.origin.x, (parentRect.origin.y ), parentRect.size.width, (parentRect.size.height ));
    self.barHostView = [(CPTGraphHostingView *) [CPTGraphHostingView alloc]initWithFrame:parentRect ];
    self.barHostView.allowPinchScaling = NO;
    [self.barGraphImage addSubview:self.barHostView];
    
}

-(void)configureGraph {
    // 1 - Create and initialize graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.hostView.bounds];
    self.hostView.hostedGraph = graph;
    graph.paddingLeft = 0.0f;
    graph.paddingTop = 0.0f;
    graph.paddingRight = 0.0f;
    graph.paddingBottom = 0.0f;
    graph.axisSet = nil;

    
    //2 - Set up text style
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    
    textStyle.fontName = [[NSString alloc]initWithFormat:@"Helvetica-Bold"];
    textStyle.fontSize = 12.0f;
    
    //3 - Configure title
    NSString *title = [[NSString alloc]initWithFormat:@"Portfolio"];
    graph.title = title;
    graph.titleTextStyle = textStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -12.0f);
    
    //4 - Set Theme
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainWhiteTheme]];
    
}

-(void)configureChart {
    // 1 - Get reference to graph
    CPTGraph * graph = self.hostView.hostedGraph;
    
    // 2 - Create Graph
    CPTPieChart *pieChart = [[CPTPieChart alloc] init];
    pieChart.dataSource = self;
    pieChart.delegate = self;
    pieChart.pieRadius = (self.hostView.bounds.size.height * 0.7) / 2;
    pieChart.identifier = graph.title;
    pieChart.startAngle = M_PI_4;
    pieChart.sliceDirection = CPTPieDirectionClockwise;
    
    // 3 - Create Gradient
    CPTGradient *overlayGradient = [[CPTGradient alloc] init];
    overlayGradient.gradientType = CPTGradientTypeRadial;
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.0]
                                         atPosition:0.9];
    overlayGradient = [overlayGradient addColorStop:[[CPTColor blackColor] colorWithAlphaComponent:0.4]
                                         atPosition:1.0];
    pieChart.overlayFill = [CPTFill fillWithGradient:overlayGradient];
    
    // 4 - Add Chart to graph
    
    [graph addPlot:pieChart];

}

-(NSNumber *)maxShares
{
    NSNumber *max = [[NSNumber alloc]initWithInt:0];
    for(int i = 0; i < [stockValues count]; i++)
    {
        if([[[stockValues objectAtIndex:i] valueForKey:@"SHARES"] intValue] > [max intValue])
        {
            max = [[stockValues objectAtIndex:i]valueForKey:@"SHARES"];
            
        }
    }
    return max;
}

-(void)configureLegend {
    
    // 1 - Get graph instance
    CPTGraph *graph = self.hostView.hostedGraph;
    
    // 2 - Create Legend
    CPTLegend *theLegend = [CPTLegend legendWithGraph:graph];
    
    // 3 - Configure legend
    CPTMutableTextStyle *textStyle = [CPTMutableTextStyle textStyle];
    textStyle.color = [CPTColor grayColor];
    
    textStyle.fontName = [[NSString alloc]initWithFormat:@"Helvetica-Bold"];
    textStyle.fontSize = 12.0f;
    
    theLegend.textStyle = textStyle;
    theLegend.numberOfColumns = 1;
    theLegend.fill = [CPTFill fillWithColor:[CPTColor whiteColor]];
    theLegend.borderLineStyle = [CPTLineStyle lineStyle];
    theLegend.cornerRadius = 2.0;
    
    // 4 - Add Legend to graph
    graph.legend = theLegend;
    graph.legendAnchor = CPTRectAnchorRight ;
    CGFloat legendPadding = -(self.accntImage.bounds.size.width / 40);
    graph.legendDisplacement = CGPointMake(legendPadding, 0.0);

}

// BAR PLOT STUFF!

#pragma mark - Chart behavior
-(void) initBarPlot
{
    
    [self configureBarGraph];
    [self configureBarPlots];
    [self configureBarAxes];
}

-(void) configureBarGraph
{
    // 1 - Creat the graph
    CPTGraph *graph = [[CPTXYGraph alloc] initWithFrame:self.barHostView.bounds ];
    graph.plotAreaFrame.masksToBorder = NO;
    self.barHostView.hostedGraph = graph;
    graph.delegate = self;
    
    
    // 2 - Configure the graph
    [graph applyTheme:[CPTTheme themeNamed:kCPTPlainBlackTheme]];
    graph.paddingBottom = 30.0f;
    graph.paddingLeft   = 30.0f;
    graph.paddingTop    = -1.0f;
    graph.paddingRight  = -5.0f;
    
    // 3 - Set up styles
    CPTMutableTextStyle *titleStyle = [CPTMutableTextStyle textStyle];
    titleStyle.color = [CPTColor whiteColor];
    titleStyle.fontName = @"Helvetica-Bold";
    titleStyle.fontSize = 12.0;
    
    // 4 - Set up title
    NSString *title = @"Portfolio Stocks";
    graph.title = title;
    graph.titleTextStyle = titleStyle;
    graph.titlePlotAreaFrameAnchor = CPTRectAnchorTop;
    graph.titleDisplacement = CGPointMake(0.0f, -16.0f);
    
    // 5 - Set up plot space
    CGFloat xMin = 0.0f;
    CGFloat xMax = [stockValues count] ;
    
    CGFloat yMin = 0.0f;
    CGFloat yMax = [[self maxShares] floatValue] + 2.0f;
    
    CPTXYPlotSpace *plotSpace = (CPTXYPlotSpace *) graph.defaultPlotSpace;
    plotSpace.xRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(xMin)
                                                    length:CPTDecimalFromFloat(xMax)];
    plotSpace.yRange = [CPTPlotRange plotRangeWithLocation:CPTDecimalFromFloat(yMin)
                                                    length:CPTDecimalFromFloat(yMax)];
    
    
}

- (void) configureBarPlots
{
    // 1 - Set up the three plots
    
    CPTBarPlot * barPlot = [CPTBarPlot tubularBarPlotWithColor:[CPTColor blueColor] horizontalBars:NO];
    
    // 2 - Set up line style
    CPTMutableLineStyle *barLineStyle = [[CPTMutableLineStyle alloc] init];
    barLineStyle.lineColor = [CPTColor lightGrayColor];
    barLineStyle.lineWidth = 0.5;
    
    // 3 - Add plots to graph
    CPTGraph *graph = self.barHostView.hostedGraph;
    CGFloat barX = CPDBarInitialX;
    
        barPlot.dataSource = self;
        barPlot.delegate = self;
        barPlot.barWidth = CPTDecimalFromDouble(CPDBarWidth);
        barPlot.barOffset = CPTDecimalFromDouble(barX);
        barPlot.lineStyle = barLineStyle;
        barPlot.identifier = @"barPlot";
    
        [graph addPlot:barPlot toPlotSpace:graph.defaultPlotSpace];
    
}

-(void) configureBarAxes
{
    // 1 - Configure Styles
    CPTMutableTextStyle *axisTitleStyle = [CPTMutableTextStyle textStyle];
    axisTitleStyle.color = [CPTColor whiteColor];
    axisTitleStyle.fontName = @"Helvetica-Bold";
    axisTitleStyle.fontSize = 12.0f;
    
    CPTMutableLineStyle *axisLineStyle = [CPTMutableLineStyle lineStyle];
    axisLineStyle.lineWidth = 1.0f;
    axisLineStyle.lineColor = [[CPTColor whiteColor] colorWithAlphaComponent:1];
    
    // 2 - Get the graph's axis set
    CPTXYAxisSet *axisSet = (CPTXYAxisSet *) self.barHostView.hostedGraph.axisSet;
    
    // 3 - Configure the x-axis
    axisSet.xAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
    axisSet.xAxis.title = @"Stock";
    axisSet.xAxis.titleTextStyle = axisTitleStyle;
    axisSet.xAxis.titleOffset = 10.0f;
    axisSet.xAxis.axisLineStyle = axisLineStyle;
    axisSet.xAxis.minorTicksPerInterval = 5.0f;
    axisSet.xAxis.axisLabels = nil;
    
    // 4 - Configure the y-axis
	axisSet.yAxis.labelingPolicy = CPTAxisLabelingPolicyNone;
	axisSet.yAxis.title = @"Shares";
	axisSet.yAxis.titleTextStyle = axisTitleStyle;
	axisSet.yAxis.titleOffset = 5.0f;
	axisSet.yAxis.axisLineStyle = axisLineStyle;
    axisSet.yAxis.axisLabels = nil;
}

-(void)hideAnnotation:(CPTGraph *)graph {
	if ((graph.plotAreaFrame.plotArea) && (self.stockAnnotation)) {
		[graph.plotAreaFrame.plotArea removeAnnotation:self.stockAnnotation];
		self.stockAnnotation = nil;
	}
}
#pragma mark - CPTBarPlotDelegate methods
- (void)barPlot: (CPTBarPlot *)plot barWasSelectedAtRecordIndex:(NSUInteger)index
{
    
    NSLog(@"Clicked on bar plot");
    
    // 2 - Create style, if necessary
    static CPTMutableTextStyle *style = nil;
    if(!style)
    {
        style = [CPTMutableTextStyle textStyle];
        style.color = [CPTColor yellowColor];
        style.fontSize = 16.0f;
        style.fontName = @"Helvetica-Bold";
    }
    
    // 3 - Create annotation, if necessary
    NSNumber *share = [self numberForPlot:plot field:CPTBarPlotFieldBarTip recordIndex:index];
    if (!self.stockAnnotation)
    {
        NSNumber *x = [NSNumber numberWithInt:0];
        NSNumber *y = [NSNumber numberWithInt:0];
        NSArray *anchorPoint = [NSArray arrayWithObjects:x, y, nil];
        self.stockAnnotation = [[CPTPlotSpaceAnnotation alloc] initWithPlotSpace:plot.plotSpace anchorPlotPoint:anchorPoint] ;
    }
    
    
    // 5 - Create text later for annotation
    NSString *stock = [[NSString alloc]initWithFormat:@"%@: %i Shares", [[stockValues objectAtIndex:index] valueForKey:@"SYMBOL"],
                            [share intValue]];
    CPTTextLayer *textLayer = [[CPTTextLayer alloc] initWithText:stock style:style];
    self.stockAnnotation.contentLayer = textLayer;
    
    // 6 - Get plot index based on identifier
    NSInteger plotIndex = 0;

    
    // 7 - Get the anchor point for annotation
    CGFloat x = index + CPDBarInitialX + (plotIndex * CPDBarWidth);
    NSNumber *anchorX = [NSNumber numberWithFloat:x];
    CGFloat y = [stock floatValue] + 1.0f;
    NSNumber *anchorY = [NSNumber numberWithFloat:y];
    self.stockAnnotation.anchorPlotPoint = [NSArray arrayWithObjects:anchorX, anchorY, nil];
    
    // 8 Add the annotation
    [plot.graph.plotAreaFrame.plotArea addAnnotation:self.stockAnnotation];
    
}



@end
