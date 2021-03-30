Pod::Spec.new do |spec|
  spec.name           = "SPStarView"
  spec.version        = "0.0.1"
  spec.summary        = "A simple star rating view."
  spec.homepage       = "https://github.com/swiftprimer/SPStarView.git"
  spec.license        = "MIT"
  spec.author         = { "高文立" => "swiftprimer@foxmail.com" }
  spec.source         = { :git => "https://github.com/swiftprimer/SPStarView.git", :tag => "#{spec.version}" }
  spec.source_files   = "Classes", "Classes/**/*"
  spec.exclude_files  = "Classes/Exclude"
  spec.swift_version  = '5.0'
  spec.dependency "JSONKit"

end
