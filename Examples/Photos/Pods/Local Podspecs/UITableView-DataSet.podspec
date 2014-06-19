Pod::Spec.new do |s|
  s.name          = "UITableView-DataSet"
  s.version       = "1.1"
  s.summary       = "A drop-in UITableView category for showing empty datasets whenever the UITableView has no content to display"
  s.description   = "It will work automatically, by just setting the dataSetSource and dataSetDelegate, and returning the data source content requiered."
  s.homepage      = "https://github.com/dzenbot/UITableView-DataSet"
  s.license       = { :type => 'MIT', :file => 'LICENSE' }
  s.author        = { "dzenbot" => "iromero@dzen.cl" }
  s.platform      = :ios, '7.0'
  s.source        = { :git => "https://github.com/dzenbot/UITableView-DataSet.git", :tag => "v#{s.version}" }
  s.source_files  = 'Classes', 'Source/**/*.{h,m}'
  s.requires_arc  = true
  s.framework     = "UIKit"
end
