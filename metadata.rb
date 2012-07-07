maintainer       "Opscode, Inc."
maintainer_email "cookbooks@opscode.com"
license          "Apache 2.0"
description      "Deploys and configures Ruby-based applications"
long_description  IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          "1.0.0"

%w{ application runit unicorn apache2 passenger_apache2 rbenv ruby_build nginx }.each do |cb|
  depends cb
end
