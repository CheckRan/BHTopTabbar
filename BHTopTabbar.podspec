Pod::Spec.new do |s|

  s.name         = "BHTopTabbar"
  s.version      = "0.1.1"
  s.summary      = "只有当前页面 在显示的时候才会加载,下载等 , 可以节约很多的内存 , 宝贵的流量"

  s.homepage     = "https://github.com/CheckRan/BHTopTabbar"
  # s.screenshots  = "www.example.com/screenshots_1.gif", "www.example.com/screenshots_2.gif"



  s.license      = 'Apache'
  # s.license      = { :type => "MIT", :file => "FILE_LICENSE" }


  s.author             = { "冉俊雄" => "1026609136@qq.com" }
  # Or just: s.author    = "冉俊雄"
  # s.authors            = { "冉俊雄" => "1026609136@qq.com" }
  # s.social_media_url   = "http://twitter.com/冉俊雄"


  s.platform     = :ios ,"7.0"
  # s.platform     = :ios, "5.0"



  s.source       = { :git => "https://github.com/CheckRan/BHTopTabbar.git", :tag => s.version.to_s }


  s.source_files  = "BHTopTabbar/**/*"
  # s.exclude_files = "Classes/Exclude"

  # s.public_header_files = "Classes/**/*.h"


  s.resource  = "BHTopTabbar/resource.bundle"
  # s.resources = "BHTopTabbar/**/*.nib"

  # s.preserve_paths = "FilesToSave", "MoreFilesToSave"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }
  s.dependency "Masonry"

end
