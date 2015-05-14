//
//  MediaStreamPlayerController.m
//  MediaStreamer
//
//  Created by Georgios Taskos on 5/12/15.
//  Copyright (c) 2015 Xplat Solutions. All rights reserved.
//

#import "MediaStreamPlayerController.h"

@interface MediaStreamPlayerController ()

@property (strong, nonatomic) NSTimer* durationTimer;

@property (weak, nonatomic) IBOutlet UIButton *playPauseButton;
@property (weak, nonatomic) IBOutlet UIButton *stopButton;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *bufferingLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

@end

@implementation MediaStreamPlayerController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.mediaTrack.artworkURL) {
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.mediaTrack.artworkURL]] queue:[NSOperationQueue new] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
            if (!connectionError) {
                UIImage* image = [UIImage imageWithData:data];
                if (image) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.artworkImageView.image = image;
                    });
                }
            }
        }];
    }
    
    self.titleLabel.text = self.mediaTrack.title;
    self.durationTimer = [NSTimer timerWithTimeInterval:0.001f target:self selector:@selector(tick) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.durationTimer forMode:NSRunLoopCommonModes];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    [self.mediaStreamPlayer stop];
}

- (void) tick {
    if ([self.mediaStreamPlayer duration] != 0) {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.durationLabel.text = [NSString stringWithFormat:@"%@ - %@", [self formatTimeFromSeconds:[self.mediaStreamPlayer progress]], [self formatTimeFromSeconds:[self.mediaStreamPlayer duration]]];
        });
    }
    else {
        dispatch_async(dispatch_get_main_queue(), ^{
            self.durationLabel.text = @"";
        });
    }
    self.bufferingLabel.alpha = [self.mediaStreamPlayer state] == MediaStreamAudioPlayerStatePlaying ? 1.0f : 0.0f;
}

-(NSString*) formatTimeFromSeconds:(int)totalSeconds {
    int seconds = totalSeconds % 60;
    int minutes = (totalSeconds / 60) % 60;
    int hours = totalSeconds / 3600;
    
    return [NSString stringWithFormat:@"%02d:%02d:%02d", hours, minutes, seconds];
}

- (IBAction)playPause:(UIButton *)sender {
    if ([self.mediaStreamPlayer state] == MediaStreamAudioPlayerStatePaused) {
        [self.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.mediaStreamPlayer resume];
    }
    else if ([self.mediaStreamPlayer state] == MediaStreamAudioPlayerStatePlaying) {
        [self.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
        [self.mediaStreamPlayer pause];
    }
    else {
        if (self.mediaTrack) {
        [self.playPauseButton setImage:[UIImage imageNamed:@"pause"] forState:UIControlStateNormal];
        [self.mediaStreamPlayer play:self.mediaTrack.streamURL];
        }
    }
}

- (IBAction)stop:(UIButton *)sender {
    [self.playPauseButton setImage:[UIImage imageNamed:@"play"] forState:UIControlStateNormal];
    [self.mediaStreamPlayer stop];
}

@end
