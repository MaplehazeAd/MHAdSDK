Pod::Spec.new do |s|
  s.name         = 'MHAdSDK'
  s.version      = '1.3.8.3'
  s.summary      = 'A local framework for advertisement SDK.'
  s.description = <<-DESC
    MHAdSDK 是枫岚互联提供的 iOS 广告聚合 SDK，使用 Objective-C 编写，支持多广告平台集成。支持优量汇，爱奇艺SDK接入。
  DESC

  s.homepage     = 'https://github.com/MaplehazeAd/MHAdSDK'
  # License 授权文件
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { 'MaplehazeAd' => 'rd@maplehaze.cn' }

  # 指定源
  s.source       = { :git => 'https://github.com/MaplehazeAd/MHAdSDK.git', :tag => s.version.to_s }

  # 预编译的 xcframework
  s.vendored_frameworks = 'MHAdSDK/MHAdSDK.xcframework'

  # 支持的最低 iOS 系统版本
  s.platform     = :ios, '11.0'
  s.requires_arc = true

end
