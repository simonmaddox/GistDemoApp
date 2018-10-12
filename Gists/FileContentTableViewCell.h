//
//  FileContentTableViewCell.h
//  Gists
//
//  Created by Simon Maddox on 12/10/2018.
//  Copyright © 2018 Maddox Ltd. All rights reserved.
//

#import <UIKit/UIKit.h>

@class File;

NS_ASSUME_NONNULL_BEGIN

@interface FileContentTableViewCell : UITableViewCell

@property (nonatomic, strong) File *file;

@end

NS_ASSUME_NONNULL_END
