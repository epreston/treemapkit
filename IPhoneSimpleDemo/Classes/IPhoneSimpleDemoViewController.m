#import "IPhoneSimpleDemoViewController.h"

@implementation IPhoneSimpleDemoViewController

@synthesize fruits;

#pragma mark -

- (void)updateCell:(TreemapViewCell *)cell forIndex:(NSInteger)index {
	NSNumber *val = [fruits[index] valueForKey:@"value"];
	cell.textLabel.text = [fruits[index] valueForKey:@"name"];
	cell.valueLabel.text = [val stringValue];
	cell.backgroundColor = [UIColor colorWithHue:(float)index / (fruits.count + 3)
									  saturation:1 brightness:0.75 alpha:1];
}

#pragma mark -
#pragma mark TreemapView delegate

- (void)treemapView:(TreemapView *)treemapView tapped:(NSInteger)index {
	/*
	 * change the value
	 */
	NSDictionary *dic = fruits[index];
	[dic setValue:@([[dic valueForKey:@"value"] intValue] + 300)
		   forKey:@"value"];

	/*
	 * resize rectangles with animation
	 */
	[UIView beginAnimations:@"reload" context:nil];
	[UIView setAnimationDuration:0.5];

	[(TreemapView *)self.view reloadData];

	[UIView commitAnimations];

	/*
	 * highlight the background
	 */
	[UIView beginAnimations:@"highlight" context:nil];
	[UIView setAnimationDuration:1.0];

	TreemapViewCell *cell = (TreemapViewCell *)(self.view.subviews)[index];
	UIColor *color = cell.backgroundColor;
	[cell setBackgroundColor:[UIColor whiteColor]];
	[cell setBackgroundColor:color];

	[UIView commitAnimations];
}

- (void)treemapView:(TreemapView *)treemapView updateCell:(TreemapViewCell *)cell forIndex:(NSInteger)index forRect:(CGRect)rect {
	[self updateCell:cell forIndex:index];
}

#pragma mark -
#pragma mark TreemapView data source

- (NSArray *)valuesForTreemapView:(TreemapView *)treemapView {
	if (!fruits) {
		NSBundle *bundle = [NSBundle mainBundle];
		NSString *plistPath = [bundle pathForResource:@"data" ofType:@"plist"];
		NSArray *array = [[NSArray alloc] initWithContentsOfFile:plistPath];

		self.fruits = [[NSMutableArray alloc] initWithCapacity:array.count];
		for (NSDictionary *dic in array) {
			NSMutableDictionary *mDic = [NSMutableDictionary dictionaryWithDictionary:dic];
			[fruits addObject:mDic];
		}
        
        [array release];
	}

	NSMutableArray *values = [NSMutableArray arrayWithCapacity:fruits.count];
	for (NSDictionary *dic in fruits) {
		[values addObject:[dic valueForKey:@"value"]];
	}
    
	return values;
}

- (TreemapViewCell *)treemapView:(TreemapView *)treemapView cellForIndex:(NSInteger)index forRect:(CGRect)rect {
	TreemapViewCell *cell = [[TreemapViewCell alloc] initWithFrame:rect];
	[self updateCell:cell forIndex:index];
	return [cell autorelease];
}


#pragma mark -

- (void) didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
    /*
    * resize rectangles with animation
    */
    [UIView beginAnimations:@"reload" context:nil];
    [UIView setAnimationDuration:0.5];

    [(TreemapView *)self.view reloadData];

    [UIView commitAnimations];
}

- (BOOL) shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
}

- (void)viewDidUnload {
	[super viewDidUnload];

	fruits = nil;
}

- (void)dealloc {
	[fruits release];

	[super dealloc];
}

@end
