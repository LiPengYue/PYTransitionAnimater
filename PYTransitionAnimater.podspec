
Pod::Spec.new do |s|
s.name             = 'PYTransitionAnimater'
s.version          = '0.3.0'
s.summary          = '关于转场动画的工具'

s.description      = <<-DESC
转场动画的工具类，block设置动画，有默认动画，枚举配置。
DES

s.homepage         = 'https://github.com/LiPengYue/PYTransitionAnimater'
s.license          = { :type => 'MIT', :file => 'LICENSE' }
s.author           = { 'LiPengYue' => '702029772@qq.com' }
s.source           = { :git => 'https://github.com/LiPengYue/PYTransitionAnimater.git', :tag => s.version.to_s, :submodules => true }

s.ios.deployment_target = '8.0'

s.source_files = 'PYTransitionAnimater/Classes/**/*'
end

