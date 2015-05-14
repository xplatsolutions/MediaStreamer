//
//  ViewController.m
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/11/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import "SearchViewController.h"
#import <TheSidebarController/TheSidebarController.h>
#import "MediaTrack.h"
#import "MediaStreamPlayerController.h"
#import "MediaServiceProtocol.h"
#import "MediaTypeFactory.h"
#import "MediaSourceSelectorView.h"

#import "SpotifyService.h"

@interface SearchViewController () <UISearchBarDelegate>

@property (strong, nonatomic) NSArray* tracks;
@property (strong, nonatomic) id<MediaServiceProtocol> mediaService;
@property (strong, nonatomic) id<MediaStreamPlayerProtocol> mediaStreamPlayer;

@property (strong, nonatomic) MediaSourceSelectorView* mediaSourceSelectorView;

@end

@implementation SearchViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UISearchBar* searchBar = [[UISearchBar alloc] init];
    searchBar.delegate = self;
    searchBar.placeholder = @"Search tracks...";
    self.navigationItem.titleView = searchBar;
    
    self.tracks = @[];
    self.mediaService = [MediaTypeFactory serviceForMediaType:MediaServiceTypeSoundCloud];
    self.mediaStreamPlayer = [MediaTypeFactory playerForMediaType:MediaServiceTypeSoundCloud];

    self.mediaSourceSelectorView = [MediaSourceSelectorView new];
    self.mediaSourceSelectorView.hidden = YES;
    self.mediaSourceSelectorView.alpha = 0.0f;

    [self.view insertSubview:self.mediaSourceSelectorView belowSubview:self.navigationController.navigationBar];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(mediaSourceDidChanged:) name:MediaSourceDidChangedNotification object:nil];
}

- (IBAction)sourceChange:(UIBarButtonItem *)sender {
    [self showHideMediaSourceSelectorView];
}

- (void) showHideMediaSourceSelectorView {
    self.mediaSourceSelectorView.hidden = !self.mediaSourceSelectorView.hidden;
    self.mediaSourceSelectorView.alpha = self.mediaSourceSelectorView.hidden ? 0.0f : 1.0f;
}

- (void) mediaSourceDidChanged:(NSNotification*)notification {
    if (notification) {
        if (notification.userInfo) {
            NSNumber* serviceTypeNumber = [notification.userInfo valueForKey:MediaServiceTypeKey];
            MediaServiceType serviceType = [serviceTypeNumber integerValue];
            self.mediaService = [MediaTypeFactory serviceForMediaType:serviceType];
            self.mediaStreamPlayer = [MediaTypeFactory playerForMediaType:serviceType];
            [self showHideMediaSourceSelectorView];
        }
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
    [self searchForeMediaTracks:searchBar.text];
}

- (void) searchForeMediaTracks:(NSString*)searchText {
    [self.mediaService search:searchText withCompletionHandler:^(NSArray * results) {
       self.tracks = results;
       [self.tableView reloadData];
    }];
}

- (IBAction)showLeftMenu:(UIBarButtonItem *)sender {    
    if(self.sidebarController.sidebarIsPresenting) {
        [self.sidebarController dismissSidebarViewController];
    }
    else {
        [self.sidebarController presentLeftSidebarViewController];
    }
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    [self searchForeMediaTracks:searchText];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.tracks ? self.tracks.count : 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:@"TrackCell" forIndexPath:indexPath];
    
    MediaTrack* mediaTrack = self.tracks[indexPath.row];
    cell.textLabel.text = mediaTrack.title;
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if ([segue.identifier isEqualToString:@"playMediaTrackSegue"]) {
        MediaStreamPlayerController* streamController = segue.destinationViewController;
        streamController.mediaTrack = self.tracks[[self.tableView indexPathForSelectedRow].row];
        streamController.mediaStreamPlayer = self.mediaStreamPlayer;
    }
}

@end
