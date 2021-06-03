Pod::Spec.new do |spec|
  spec.name           = "SPStarView"
  spec.version        = "1.0.13"
  spec.summary        = "A simple star rating view."
  spec.homepage       = "https://github.com/gaookey/SPStarView"
  spec.license        = "MIT"
  spec.author         = { "高文立" => "gaookey@gmail.com" }
  spec.platform       = :ios, "10.0"
  spec.source         = { :git => "https://github.com/gaookey/SPStarView.git", :tag => "#{spec.version}" }
  spec.source_files   = "Classes", "Classes/**/*"
  spec.resources = "Resources/**/*.png"
  spec.swift_version  = "5.0"
  spec.dependency "SnapKit"

end
