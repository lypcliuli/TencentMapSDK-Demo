//
//  ViewController.h
//  qiqi
//
//  Created by LYPC on 2023/8/30.
//

#import <UIKit/UIKit.h>
//引入地图库头文件
#import <QMapKit/QMapKit.h>

#import <QMapKit/QMSSearcher.h>

#import "QDAnnotationView.h"

@interface ViewController : UIViewController <QMapViewDelegate, QMSSearchDelegate>

@property (nonatomic, strong) QMapView *mapView;
@property (nonatomic, strong) QMSSearcher *mySearcher;

// 位置
@property (nonatomic, copy) NSString *address;
@property (nonatomic, copy) NSString *cityName;
// 经纬度
@property (nonatomic, assign) CLLocationCoordinate2D locationCoordinate;

// 发起附近检索
@property (nonatomic, strong) QMSPoiSearchOption *busPoiSearchOption;
@property (nonatomic, strong) QMSPoiSearchOption *subwayPoiSearchOption;

@property (nonatomic, strong) QMSPoiSearchOption *hotelPoiSearchOption;
@property (nonatomic, strong) QMSPoiSearchOption *foodPoiSearchOption;
@property (nonatomic, strong) QMSPoiSearchOption *parkPoiSearchOption;

// 附近交通路线数据
@property (nonatomic, strong) NSArray *busPoiDatas; // 公交
@property (nonatomic, strong) NSArray *subwayPoiDatas; // 地铁
// 附近酒店数据
@property (nonatomic, strong) NSArray *hotelPoiDatas;
// 附近美食数据
@property (nonatomic, strong) NSArray *foodPoiDatas;
// 附近停车场数据
@property (nonatomic, strong) NSArray *parkPoiDatas;

// 标记搜索对应周边数据后 是否 需要直接添加标记Annotation
@property (nonatomic, assign) BOOL isShouldAdd;

// 临时存放标注 用于清除时
@property (nonatomic, strong) NSMutableArray *tempAnnotations;
// 当前步行规划plan（步行时长、距离等）
@property (nonatomic, strong) QMSRoutePlan *walkingRoutePlan;

@end

