//
//  QDAnnotationView.m
//  qiqi
//
//  Created by LYPC on 2023/8/31.
//

#import "QDAnnotationView.h"

@interface QDAnnotationView ()


@property (nonatomic, strong) UILabel *titleL;
@property (nonatomic, strong) UIImageView *arrowImgV;

@property (nonatomic, copy) NSString *title;

@end

@implementation QDAnnotationView

+ (QDAnnotationView *)viewWithMap:(QMapView *)mapView annotation:(id <QAnnotation>)annotation {
    static NSString *annotationIdentifier = @"pointAnnotation";
    QDAnnotationView *pinView = (QDAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationIdentifier];
    if (!pinView) {
        pinView = [[QDAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationIdentifier];
        [pinView setupUI];
    }
    pinView.title = annotation.title;
    [pinView setupData];
    return pinView;
}

- (void)setupData {
    if ([self.title isEqualToString:@"我的位置"]) {
        self.titleL.hidden = YES;
        self.arrowImgV.hidden = YES;
        self.canShowCallout = YES;
        self.image = [UIImage imageNamed:@"mylocation"];
    } else {
        self.titleL.hidden = NO;
        self.arrowImgV.hidden = NO;
        self.titleL.text = self.title;
        CGSize size = [self.title boundingRectWithSize:CGSizeMake(MAXFLOAT, 15) options: NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:self.titleL.font forKey:NSFontAttributeName] context:nil].size;
        self.titleL.frame = CGRectMake(0, 0, size.width+5, 30);
        self.arrowImgV.center = CGPointMake(CGRectGetMidX(self.titleL.frame), 30);
    }
}

- (void)setupUI {
    self.arrowImgV.frame = CGRectMake(0, 0, 15, 15);
    [self addSubview:self.arrowImgV];
    self.titleL.frame = CGRectMake(0, 0, 0, 30);
    [self addSubview:self.titleL];
}

- (UILabel *)titleL {
    if (!_titleL) {
        _titleL = [[UILabel alloc] init];
        _titleL.textColor = [UIColor whiteColor];
        _titleL.textAlignment = NSTextAlignmentCenter;
        _titleL.backgroundColor = [UIColor blueColor];
        _titleL.numberOfLines = 1;
        _titleL.font = [UIFont systemFontOfSize:12];
        _titleL.layer.masksToBounds = YES;
        _titleL.layer.cornerRadius = 15;
        _titleL.hidden = YES;
    }
    return _titleL;
}

- (UIImageView *)arrowImgV {
    if (!_arrowImgV) {
        _arrowImgV = [[UIImageView alloc] init];
        _arrowImgV.image = [UIImage imageNamed:@"arrrowbottom"];
        _arrowImgV.hidden = YES;
    }
    return _arrowImgV;
}

@end
