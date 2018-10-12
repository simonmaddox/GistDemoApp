//
//  CommentTableViewCell.h
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Comment;

NS_ASSUME_NONNULL_BEGIN

@interface CommentTableViewCell : UITableViewCell

@property (nonatomic, strong) Comment *comment;

@end

NS_ASSUME_NONNULL_END
