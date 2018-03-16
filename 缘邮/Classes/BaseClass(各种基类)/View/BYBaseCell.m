//
//  BYBaseCell.m
//  缘邮
//
//  Created by lilu on 2017/6/7.
//  Copyright © 2017年 chujunhe1234. All rights reserved.
//

#import "BYBaseCell.h"

@implementation BYBaseCell

+ (instancetype)cellWithTableView:(UITableView *)tableView {
    NSString *identifier = NSStringFromClass([self class]);
    // 1.缓存中取
    BYBaseCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    // 2.创建
    if (cell == nil) {
        cell = [[self alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        UIView *bgColorView = [[UIView alloc] init];
        bgColorView.dk_backgroundColorPicker = DKColor_BACKGROUND_CELL_SELECT;
        bgColorView.layer.masksToBounds = YES;
        cell.selectedBackgroundView = bgColorView;
    }
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        //do something
    }
    self.contentView.dk_backgroundColorPicker = DKColor_BACKGROUND;
    self.dk_backgroundColorPicker = DKColor_BACKGROUND;
    return self;
}

@end
