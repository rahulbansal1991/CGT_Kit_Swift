Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "CGT_Pod_Swift"
  s.version      = "1.1.5"
  s.summary      = "CGT_Pod_Swift contains pods of all the basic and necessary libraries"

  # This description is used to generate tags and improve search results.
  s.description  = <<-DESC
* An extensive blocks-based Swift wrapper. CGT_Pod_Swift contains pods of all the basic and necessary libraries
                   DESC
  s.homepage     = "http://www.cgt.co.in"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "MIT"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author             = { "Rahul Bansal" => "rahul.bansal@cgt.co.in" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "8.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :git => "https://github.com/rahulbansal1991/CGT_Kit_Swift.git", :tag => "1.1.5" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source_files = "NetworkManager/*.{swift}"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = true

  # Networking
  s.dependency 'Alamofire'

  # Loading
  s.dependency 'MBProgressHUD'

  # Internet Connectivity
#  s.dependency 'Reachability'

  # JSON Parsing
  s.dependency 'ObjectMapper'

  # Utility library
#  s.dependency 'BFKit-Swift'

  # Image downloading/caching (requirement: iOS: 9.3)
  s.dependency 'Kingfisher'

#  s.prefix_header_contents = "#import <AFNetworking/AFNetworking.h>"

end
