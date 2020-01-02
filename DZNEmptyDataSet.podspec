@version = '2.0'

Pod::Spec.new do |s|
  s.name                    = 'DZNEmptyDataSet'
  s.version                 = @version
  s.summary                 = 'A drop-in UITableView/UICollectionView superclass extension for displaying placeholders for whenever the view has no content to display.'
  s.homepage                = 'https://github.com/dzenbot/DZNEmptyDataSet'
  s.license                 = { :type => 'MIT', :file => 'LICENSE' }
  s.author                  = { 'Ignacio Romero Zurbuchen' => 'ignacio.romeroz@gmail.com' }

  s.source = {
    :git => 'https://github.com/dzenbot/DZNEmptyDataSet.git',
    :tag => 'v#{s.version}',
    :branch => 'master'
  }

  s.source_files            = 'Source/*.{swift}'
  s.preserve_paths          = 'Source/*'
  s.requires_arc            = true
  s.swift_versions          = ['4.0', '5.0', '5.1']

  s.ios.deployment_target   = '11.0'
  s.tvos.deployment_target  = '11.0'

  s.ios.frameworks          = 'UIKit'
  s.tvos.frameworks         = 'UIKit'

end
