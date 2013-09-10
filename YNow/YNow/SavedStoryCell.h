//
//  SavedStoryCell.h
//  YNow
//
//  Created by Mohtashim Khan on 9/9/13.
//  Copyright (c) 2013 Yahoo. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SavedStoryCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *srcLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;



@end
