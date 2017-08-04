# encoding: UTF-8
$:.push File.expand_path('../lib', __FILE__)
require 'solidus_purchasing/version'

Gem::Specification.new do |s|
  s.name        = 'solidus_purchasing'
  s.version     = SolidusPurchasing::VERSION
  s.summary     = 'Adds ability to create purchase orders and send them to vendors'
  s.description = 'Adds accounting functionality revolving around purchasing. You will
  be able to create purchase orders - either manually or automatically based on your
  current stock level plus recent sales - send the orders to vendors, and receive
  the purchase orders when the items are received - which will automatically add them
  to stock.'
  s.license     = 'BSD-3-Clause'

  s.author    = 'Sean Denny'
  s.email     = 'seand7565@gmail.com'
  # s.homepage  = 'http://www.example.com'

  s.files = Dir["{app,config,db,lib}/**/*", 'LICENSE', 'Rakefile', 'README.md']
  s.test_files = Dir['test/**/*']

  s.add_dependency 'solidus_core', '~> 2.0'

  s.add_development_dependency 'capybara'
  s.add_development_dependency 'poltergeist'
  s.add_development_dependency 'coffee-rails'
  s.add_development_dependency 'sass-rails'
  s.add_development_dependency 'database_cleaner'
  s.add_development_dependency 'factory_girl'
  s.add_development_dependency 'rspec-rails'
  s.add_development_dependency 'rubocop', '0.37.2'
  s.add_development_dependency 'rubocop-rspec', '1.4.0'
  s.add_development_dependency 'simplecov'
  s.add_development_dependency 'sqlite3'
end
