Pod::Spec.new do |spec|
  spec.name           = "SPStarView"
  spec.version        = "1.0.11"
  spec.summary        = "A simple star rating view."
  spec.homepage       = "https://github.com/swiftprimer/SPStarView.git"
  spec.license        = "MIT"
  spec.author         = { "高文立" => "swiftprimer@foxmail.com" }
  spec.platform       = :ios, "10.0"
  spec.source         = { :git => "https://github.com/swiftprimer/SPStarView.git", :tag => "#{spec.version}" }
  spec.source_files   = "Classes", "Classes/**/*"
  spec.resources = "Resources/*.png"
  spec.swift_version  = "5.0"
  spec.dependency "SnapKit"

end
