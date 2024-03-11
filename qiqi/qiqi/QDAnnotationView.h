//
//  QDAnnotationView.h
//  qiqi
//
//  Created by LYPC on 2023/8/31.
//

#import <QMapKit/QMapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface QDAnnotationView : QPinAnnotationView

+ (QDAnnotationView *)viewWithMap:(QMapView *)mapView annotation:(id <QAnnotation>)annotation;

@end

NS_ASSUME_NONNULL_END
