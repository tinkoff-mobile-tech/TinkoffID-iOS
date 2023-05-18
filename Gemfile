source "https://rubygems.org"

gem 'cocoapods', '~> 1.11'
gem 'fastlane', '~> 2.209'
gem 'fastlane-plugin-changelog'
gem 'rubocop', '~> 1.25.1'
gem 'rubocop-require_tools'

plugins_path = File.join(File.dirname(__FILE__), 'fastlane', 'Pluginfile')
eval_gemfile(plugins_path) if File.exist?(plugins_path)
