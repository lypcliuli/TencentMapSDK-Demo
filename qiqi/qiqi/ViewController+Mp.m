//
//  ViewController+Mp.m
//  qiqi
//
//  Created by LYPC on 2023/9/1.
//

#import "ViewController+Mp.h"

@implementation ViewController (Mp)

- (void)searchWithGeo {
    // 逆地理编码
    QMSGeoCodeSearchOption *geoOption = [[QMSGeoCodeSearchOption alloc] init];
    [geoOption setAddress:self.address];
    [geoOption setRegion:@"广州市"];
    [self.mySearcher searchWithGeoCodeSearchOption:geoOption];
}

- (void)addMyAnnotation {
    // 设置中心点经纬度
    [self.mapView setCenterCoordinate:self.locationCoordinate animated:YES];
    
    // 我的位置
    QPointAnnotation *pointAnnotation = [[QPointAnnotation alloc] init];
    pointAnnotation.coordinate = self.locationCoordinate;
    pointAnnotation.title = @"我的位置";
    [self.mapView addAnnotation:pointAnnotation];
}

// 周边检索
- (void)poiSearch:(int)index {
    if (index == -1) {
        if (self.busPoiDatas.count == 0) {
            [self.mySearcher searchWithPoiSearchOption:self.busPoiSearchOption];
        }
    } else if (index == 0) {
        if (self.subwayPoiDatas.count == 0) {
            [self.mySearcher searchWithPoiSearchOption:self.subwayPoiSearchOption];
        }
    }  else if (index == 1) {
        if (self.hotelPoiDatas.count == 0) {
            [self.mySearcher searchWithPoiSearchOption:self.hotelPoiSearchOption];
        }
    } else if (index == 2) {
        if (self.foodPoiDatas.count == 0) {
            [self.mySearcher searchWithPoiSearchOption:self.foodPoiSearchOption];
        }
    } else if (index == 3) {
        if (self.parkPoiDatas.count == 0) {
            [self.mySearcher searchWithPoiSearchOption:self.parkPoiSearchOption];
        }
    }
}

#pragma QMapViewDelegate
- (QAnnotationView *)mapView:(QMapView *)mapView viewForAnnotation:(id<QAnnotation>)annotation {
    if ([annotation isKindOfClass:[QPointAnnotation class]]) {
        if ([annotation.title isEqualToString:@"我的位置"]) {
            QDAnnotationView *pinView = [QDAnnotationView viewWithMap:mapView annotation:annotation];
            return pinView;
        } else {
            QDAnnotationView *pinView = [QDAnnotationView viewWithMap:mapView annotation:annotation];
            return pinView;
        }
    }
    return nil;
}
// 点击标注点 绘制步行路线
- (void)mapView:(QMapView *)mapView didSelectAnnotationView:(QAnnotationView *)view {
    CLLocationCoordinate2D locationCoordinate = view.annotation.coordinate;
    NSLog(@"111111%@, %@", @(locationCoordinate.latitude), @(locationCoordinate.longitude));
    if ([view.annotation.title isEqualToString:@"我的位置"]) {
        return;
    }
    // 获取步行路线 去绘制路线
    QMSWalkingRouteSearchOption *walkOpt = [[QMSWalkingRouteSearchOption alloc] init];
    [walkOpt setFrom:[NSString stringWithFormat:@"%@,%@", @(self.locationCoordinate.latitude), @(self.locationCoordinate.longitude)]];
    [walkOpt setTo:[NSString stringWithFormat:@"%@,%@", @(locationCoordinate.latitude), @(locationCoordinate.longitude)]];
    [self.mySearcher searchWithWalkingRouteSearchOption:walkOpt];
}

#pragma QMSSearchDelegate
- (void)searchWithGeoCodeSearchOption:(QMSGeoCodeSearchOption *)geoCodeSearchOption didReceiveResult:(QMSGeoCodeSearchResult *)geoCodeSearchResult
{
    NSLog(@"geoCodeSearchResult-----:%@", geoCodeSearchResult);
    self.cityName = geoCodeSearchResult.address_components.city;
    self.locationCoordinate = geoCodeSearchResult.location;
    [self addMyAnnotation];
    // 默认进来展示公交的
    self.isShouldAdd = YES;
    [self poiSearch:-1];
}
// 获取周边检索结果
- (void)searchWithPoiSearchOption:(QMSPoiSearchOption *)poiSearchOption didReceiveResult:(QMSPoiSearchResult *)poiSearchResult {
    NSLog(@"poiSearchResult-----:%@", poiSearchResult);
    if (poiSearchOption == self.busPoiSearchOption) {
        self.busPoiDatas = poiSearchResult.dataArray;
        if (self.isShouldAdd) {
            [self addAnnotations:self.busPoiDatas];
        }
    } else if (poiSearchOption == self.subwayPoiSearchOption) {
        self.subwayPoiDatas = poiSearchResult.dataArray;
        if (self.isShouldAdd) {
            [self addAnnotations:self.subwayPoiDatas];
        }
    } else if (poiSearchOption == self.hotelPoiSearchOption) {
        self.hotelPoiDatas = poiSearchResult.dataArray;
        if (self.isShouldAdd) {
            [self addAnnotations:self.hotelPoiDatas];
        }
    } else if (poiSearchOption == self.foodPoiSearchOption) {
        self.foodPoiDatas = poiSearchResult.dataArray;
        if (self.isShouldAdd) {
            [self addAnnotations:self.foodPoiDatas];
        }
    } else if (poiSearchOption == self.parkPoiSearchOption) {
        self.parkPoiDatas = poiSearchResult.dataArray;
        if (self.isShouldAdd) {
            [self addAnnotations:self.parkPoiDatas];
        }
    }
    // 获取到数据 刷新页面展示他们
    
}
// 步行路线
- (void)searchWithWalkingRouteSearchOption:(QMSWalkingRouteSearchOption *)walkingRouteSearchOption didRecevieResult:(QMSWalkingRouteSearchResult *)walkingRouteSearchResult {
    NSLog(@"Walking result:%@. count:%ld", walkingRouteSearchResult, walkingRouteSearchResult.routes.count);
    [self.mapView removeOverlays:self.mapView.overlays];
    QMSRoutePlan *walkingRoutePlan = walkingRouteSearchResult.routes.firstObject;
    NSUInteger count = walkingRoutePlan.polyline.count;
    CLLocationCoordinate2D coordinateArray[count];
    for (int i = 0; i < count; ++i) {
        [[walkingRoutePlan.polyline objectAtIndex:i] getValue:&coordinateArray[i]];
    }
    QPolyline *polyline = [QPolyline polylineWithCoordinates:coordinateArray count:count];
    [self.mapView addOverlay:polyline];
}

// 绘制路线图
- (QOverlayView *)mapView:(QMapView *)mapView viewForOverlay:(id<QOverlay>)overlay
{
    if ([overlay isKindOfClass:[QPolyline class]]) {
        QPolylineView *polylineRender = [[QPolylineView alloc] initWithPolyline:overlay];
        polylineRender.lineWidth   = 6;
        polylineRender.strokeColor = [UIColor blueColor];
        return polylineRender;
    }
    return nil;
}

- (void)searchWithSearchOption:(QMSSearchOption *)searchOption didFailWithError:(NSError *)error
{
    NSLog(@"------：%@",error);
}
// 切换
- (void)clickAction:(UIButton *)sender {
    [self.mapView removeAnnotations:self.tempAnnotations];
    [self.mapView removeOverlays:self.mapView.overlays];

    [self.tempAnnotations removeAllObjects];
    if (sender.tag == 100 || sender.tag == 104) { // 展示公交
        [self addAnnotations:self.busPoiDatas index:-1];
    } else if (sender.tag == 105) { // 展示地铁
        [self addAnnotations:self.subwayPoiDatas index:0];
    } else if (sender.tag == 101) { // 展示酒店
        [self addAnnotations:self.hotelPoiDatas index:1];
    } else if (sender.tag == 102) { // 展示餐饮
        [self addAnnotations:self.foodPoiDatas index:2];
    } else if (sender.tag == 103) { // 展示停车场
        [self addAnnotations:self.parkPoiDatas index:3];
    }
}
- (void)addAnnotations:(NSArray *)poiDatas index:(int)index {
    if (poiDatas.count == 0) {
        self.isShouldAdd = YES;
        [self poiSearch:index];
    } else {
        [self addAnnotations:poiDatas];
    }
}

- (void)addAnnotations:(NSArray *)poiDatas {
    [self.mapView removeAnnotations:self.tempAnnotations];
    [self.tempAnnotations removeAllObjects];
    
    self.isShouldAdd = NO;
    
    for (QMSPoiData *poiData in poiDatas) {
        QPointAnnotation *pointAnnotation = [[QPointAnnotation alloc] init];
        pointAnnotation.coordinate = poiData.location;
        pointAnnotation.title = poiData.title;
        [self.mapView addAnnotation:pointAnnotation];
        [self.tempAnnotations addObject:pointAnnotation];
    }
}

@end
