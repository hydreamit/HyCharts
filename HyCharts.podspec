Pod::Spec.new do |s|
s.name         = 'HyCharts'
s.version      = '1.0.2'
s.summary      = 'HyLineChartView HyBarChartView HyKLineChartView'
s.homepage     = 'https://github.com/hydreamit/HyCharts'
s.license      = 'MIT'
s.authors      = {'Hy' => 'hydreamit@163.com'}
s.platform     = :ios, '9.0'
s.source       = {:git => 'https://github.com/hydreamit/HyCharts.git', :tag => s.version}
s.source_files = 'HyCharts/**/*.{h,m}'
s.framework    = 'UIKit'
s.requires_arc = true
end
