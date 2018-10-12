//
//  CommentTableViewCell.m
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "Comment.h"
#import "User.h"

@interface CommentTableViewCell ()
@property (weak, nonatomic) IBOutlet UILabel *userLabel;
@property (weak, nonatomic) IBOutlet UILabel *commentLabel;
@end

@implementation CommentTableViewCell

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self addObserver:self forKeyPath:NSStringFromSelector(@selector(comment)) options:NSKeyValueObservingOptionInitial | NSKeyValueObservingOptionNew context:nil];
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:NSStringFromSelector(@selector(comment))];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(comment))]){
        self.userLabel.text = self.comment.user.login;
        self.commentLabel.text = self.comment.body;
    } else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

@end
