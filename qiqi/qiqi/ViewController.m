//
//  ViewController.m
//  qiqi
//
//  Created by LYPC on 2023/8/30.
//

#import "ViewController.h"


@interface ViewController ()

@property (nonatomic, strong) UILabel *addressL;
@property (nonatomic, strong) UIButton *btn0;
@property (nonatomic, strong) UIButton *btn1;
@property (nonatomic, strong) UIButton *btn2;
@property (nonatomic, strong) UIButton *btn3;
@property (nonatomic, strong) UIButton *btn4;
@property (nonatomic, strong) UIButton *btn5;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.address = @"广州市海珠区仲恺路501号（仲恺农业工程学院海珠校区南门）";
    [self setupUI];
    
    [self searchWithGeo];
}

- (void)searchWithGeo {
}

- (void)clickAction:(UIButton *)sender {
}

- (void)setupUI {
    self.view.backgroundColor = [UIColor whiteColor];
    self.addressL.text = self.address;
    [self.view addSubview:self.addressL];
    self.addressL.frame = CGRectMake(10, 110, 400, 25);
    
    self.mapView.frame = CGRectMake(8, 140, 300, 400);
    [self.view addSubview:self.mapView];
    
    [self.view addSubview:self.btn0];
    [self.view addSubview:self.btn1];
    [self.view addSubview:self.btn2];
    [self.view addSubview:self.btn3];
    [self.view addSubview:self.btn4];
    [self.view addSubview:self.btn5];
    self.btn0.frame = CGRectMake(10, 25, 44, 25);
    self.btn1.frame = CGRectMake(60, 25, 44, 25);
    self.btn2.frame = CGRectMake(110, 25, 44, 25);
    self.btn3.frame = CGRectMake(160, 25, 60, 25);
    self.btn4.frame = CGRectMake(15, 58, 44, 25);
    self.btn5.frame = CGRectMake(70, 58, 44, 25);
}

//--------------------UI
- (UILabel *)addressL {
    if (!_addressL) {
        _addressL = [[UILabel alloc] init];
        _addressL.textColor = [UIColor blackColor];
    }
    return _addressL;
}

- (UIButton *)btn0 {
    if (!_btn0) {
        _btn0 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn0.backgroundColor = [UIColor greenColor];
        [_btn0 setTitle:@"交通" forState:UIControlStateNormal];
        [_btn0 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _btn0.tag = 100;
    }
    return _btn0;
}

- (UIButton *)btn1 {
    if (!_btn1) {
        _btn1 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn1.backgroundColor = [UIColor greenColor];
        [_btn1 setTitle:@"酒店" forState:UIControlStateNormal];
        [_btn1 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _btn1.tag = 101;
    }
    return _btn1;
}
- (UIButton *)btn2 {
    if (!_btn2) {
        _btn2 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn2.backgroundColor = [UIColor greenColor];
        [_btn2 setTitle:@"餐饮" forState:UIControlStateNormal];
        [_btn2 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _btn2.tag = 102;
    }
    return _btn2;
}
- (UIButton *)btn3 {
    if (!_btn3) {
        _btn3 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn3.backgroundColor = [UIColor greenColor];
        [_btn3 setTitle:@"停车场" forState:UIControlStateNormal];
        [_btn3 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _btn3.tag = 103;
    }
    return _btn3;
}
- (UIButton *)btn4 {
    if (!_btn4) {
        _btn4 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn4.backgroundColor = [UIColor greenColor];
        [_btn4 setTitle:@"公交" forState:UIControlStateNormal];
        [_btn4 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _btn4.tag = 104;
    }
    return _btn4;
}
- (UIButton *)btn5 {
    if (!_btn5) {
        _btn5 = [UIButton buttonWithType:UIButtonTypeCustom];
        _btn5.backgroundColor = [UIColor greenColor];
        [_btn5 setTitle:@"地铁" forState:UIControlStateNormal];
        [_btn5 addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
        _btn5.tag = 105;
    }
    return _btn5;
}

- (QMapView *)mapView {
    if (!_mapView) {
        _mapView = [[QMapView alloc] init];
        _mapView.delegate = self;
    }
    return _mapView;
}

- (QMSSearcher *)mySearcher {
    if (!_mySearcher) {
        _mySearcher = [[QMSSearcher alloc] initWithDelegate:self];
    }
    return _mySearcher;
}

- (QMSPoiSearchOption *)busPoiSearchOption {
    if (!_busPoiSearchOption) {
        _busPoiSearchOption = [[QMSPoiSearchOption alloc] init];
        // 以坐标self.locationCoordinate为中心，返回就近地点搜索结果;
        [_busPoiSearchOption setBoundaryByRegionWithCityName:self.cityName autoExtend:YES center:self.locationCoordinate];
        [_busPoiSearchOption setKeyword:@"公交站"];// 公交线路
        [_busPoiSearchOption setPage_size:6]; // 取6条数据
    }
    return _busPoiSearchOption;
}

- (QMSPoiSearchOption *)subwayPoiSearchOption {
    if (!_subwayPoiSearchOption) {
        _subwayPoiSearchOption = [[QMSPoiSearchOption alloc] init];
        [_subwayPoiSearchOption setBoundaryByRegionWithCityName:self.cityName autoExtend:YES center:self.locationCoordinate];
        [_subwayPoiSearchOption setKeyword:@"地铁站"];// 地铁线路
        [_subwayPoiSearchOption setPage_size:6];
    }
    return _subwayPoiSearchOption;
}

- (QMSPoiSearchOption *)hotelPoiSearchOption {
    if (!_hotelPoiSearchOption) {
        _hotelPoiSearchOption = [[QMSPoiSearchOption alloc] init];
        [_hotelPoiSearchOption setBoundaryByRegionWithCityName:self.cityName autoExtend:YES center:self.locationCoordinate];
        [_hotelPoiSearchOption setKeyword:@"酒店宾馆"];
        [_hotelPoiSearchOption setPage_size:6];
    }
    return _hotelPoiSearchOption;
}

- (QMSPoiSearchOption *)foodPoiSearchOption {
    if (!_foodPoiSearchOption) {
        _foodPoiSearchOption = [[QMSPoiSearchOption alloc] init];
        [_foodPoiSearchOption setBoundaryByRegionWithCityName:self.cityName autoExtend:YES center:self.locationCoordinate];
        [_foodPoiSearchOption setKeyword:@"美食"];
        [_foodPoiSearchOption setPage_size:6];
    }
    return _foodPoiSearchOption;
}

- (QMSPoiSearchOption *)parkPoiSearchOption {
    if (!_parkPoiSearchOption) {
        _parkPoiSearchOption = [[QMSPoiSearchOption alloc] init];
        [_parkPoiSearchOption setBoundaryByRegionWithCityName:self.cityName autoExtend:YES center:self.locationCoordinate];
        [_parkPoiSearchOption setKeyword:@"停车场"];
        [_parkPoiSearchOption setPage_size:6];
    }
    return _parkPoiSearchOption;
}

- (NSMutableArray *)tempAnnotations {
    if (!_tempAnnotations) {
        _tempAnnotations = [NSMutableArray array];
    }
    return _tempAnnotations;
}

@end
