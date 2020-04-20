# HyCycleView 
HyCycleView(可定制轮播:支持view/controller, 左右上下四个方向);
# HyCyclePageView  
HyCyclePageView(可定制PageView:支持无限循环、view/controller、scrollView嵌套悬停(两种解决方案)); 
# HySegmentView
HySegmentView(可定制SegmentView:支持自定义每一个item及动画view)


## 如何导入

__Podfile__

```
pod 'HyCycleView'
```

__手动导入__

直接将`HyCycleView`文件夹拖入项目中

## 如何使用

### HyCycleView

#### 链式用法

```objc
__weak typeof(self) weakSelf = self;
UIPageControl *pageControl = [[UIPageControl alloc] init];
pageControl.currentPageIndicatorTintColor = UIColor.orangeColor;

[HyCycleView cycleViewWithFrame:CGRectMake(30, 100, 150, 130)
                 configureBlock:^(HyCycleViewConfigure *configure) {

                     configure
                     .totalPage(weakSelf.imageNameArray.count)
                     .cycleClasses(@[UIImageView.class])
                     .viewWillAppear(^(HyCycleView *cycleView,
                                       UIImageView *imageView,
                                       NSInteger index,
                                       BOOL isfirstLoad){
                         if (isfirstLoad) {
                             imageView.contentMode = UIViewContentModeScaleAspectFill;
                             imageView.image = [UIImage imageNamed:weakSelf.imageNameArray[index]];
                         }
                     })
                     .roundingPageChange(^(HyCycleView *cycleView,
                                           NSInteger totalPage,
                                           NSInteger currentPage){

                         if (!pageControl.superview && totalPage > 1) {
                             CGFloat pageW = 15 * totalPage;
                             CGFloat pageH = 20;
                             CGFloat pageX = (cycleView.frame.size.width - pageW) / 2;
                             CGFloat pageY = cycleView.frame.size.height - pageH;
                             pageControl.frame = CGRectMake(pageX, pageY, pageW, pageH);
                             [cycleView addSubview:pageControl];
                             pageControl.numberOfPages = totalPage;
                         }
                         pageControl.currentPage = currentPage;
                     })
                     .clickAction(^(HyCycleView *cycleView, NSInteger index){

                         NSLog(@"clickAction====%tu", index);
                     });
                 }];
```

#### Demo图片 

* 图片轮播<br>
![图片轮播](https://github.com/hydreamit/HyCycleView/blob/master/Pictures/HyCycleView_One.gif)
* 自定义轮播<br>
![自定义轮播](https://github.com/hydreamit/HyCycleView/blob/master/Pictures/HyCycleView_Two.gif)
* 控制器轮播<br>
![控制器轮播](https://github.com/hydreamit/HyCycleView/blob/master/Pictures/HyCycleView_Three.gif)


### HyCyclePageView

#### 链式用法
```objc
- (HyCyclePageView *)cyclePageView {
    if (!_cyclePageView){
         __weak typeof(self) weakSelf = self;
        _cyclePageView = [HyCyclePageView cyclePageViewWithFrame:_scrollView.bounds
                                                  configureBlock:^(HyCyclePageViewConfigure * _Nonnull configure) {
                                                      
                                                      configure
                                                      .totalPage(9)
                                                      .hoverView(weakSelf.hoverView)
                                                      .headerView(weakSelf.headerView)
                                                      .gestureStyle(weakSelf.gestureStyle)
                                                      .cyclePageInstance(^id(HyCyclePageView *pageView, NSInteger currentIndex){
                                                          return [weakSelf creatTableViewWithPageNumber:currentIndex];
                                                      })
                                                      .horizontalScroll(^(HyCyclePageView *cyclePageView,
                                                                          NSInteger fromPage,
                                                                          NSInteger toPage,
                                                                          CGFloat progress) {
                                                                          
                                                          [weakSelf.segmentView clickItemFromIndex:fromPage
                                                                                           toIndex:toPage
                                                                                          progress:progress];
                                                      });
                                                  }];
    }
    return _cyclePageView;
}
```

#### Demo图片 

* 无头部<br>
![图片轮播](https://github.com/hydreamit/HyCycleView/blob/master/Pictures/HyCyclePageView_One.gif)
* 有头部scrollView嵌套<br>
![自定义轮播](https://github.com/hydreamit/HyCycleView/blob/master/Pictures/HyCyclePageView_Two.gif)
* 有头部scrollView嵌套 动画<br>
![控制器轮播](https://github.com/hydreamit/HyCycleView/blob/master/Pictures/HyCyclePageView_Three.gif)
* 有头部scrollView嵌套 动画 自定义View<br>
![控制器轮播](https://github.com/hydreamit/HyCycleView/blob/master/Pictures/HyCyclePageView_Four.gif)
* 淘宝首页<br>
![淘宝首页](https://github.com/hydreamit/HyCycleView/blob/master/Pictures/HyCyclePageView_TaoBao.gif)


### HySegmentView
* Demo图片<br> 
![控制器轮播](https://github.com/hydreamit/HyCycleView/blob/master/Pictures/HySegmentView.gif)
