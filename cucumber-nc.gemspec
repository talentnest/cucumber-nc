# -*- encoding: utf-8 -*-
Gem::Specification.new do |gem|
  gem.name          = 'cucumber-nc'
  gem.version       = '0.0.2'
  gem.authors       = ['Jon Frisby', 'Odin Dutton']
  gem.email         = ['jfrisby@mrjoy.com', 'odindutton@gmail.com']
  gem.description   = 'https://github.com/MrJoy/cucumber-nc'
  gem.summary       = "Cucumber formatter for Mountain Lion's Notification Center"
  gem.homepage      = 'https://github.com/MrJoy/cucumber-nc'

  gem.add_dependency 'terminal-notifier', '~> 1.6.2'
  gem.add_dependency 'cucumber', '~> 1.2'

  gem.files         = `git ls-files`.split($\)
  gem.executables   = []
  gem.test_files    = gem.files.grep(%r{^(spec)/})
  gem.require_paths = ['lib']
end
