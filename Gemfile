source "https://rubygems.org"

gem 'cocoapods', '~> 1.10.1'
gem 'fastlane', '~> 2.172.0'
gem 'fastlane-plugin-changelog'
gem 'rubocop', '~> 0.93.1'
gem 'rubocop-require_tools'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
