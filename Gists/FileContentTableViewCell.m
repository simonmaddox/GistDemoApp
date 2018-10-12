//
//  FileContentTableViewCell.m
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import "FileContentTableViewCell.h"
#import "File.h"

@interface FileContentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *contentLabel;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@end

@implementation FileContentTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(file)) options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(file))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(file))]){
        self.titleLabel.text = self.file.filename;
        self.contentLabel.text = self.file.content;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
