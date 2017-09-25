# frozen_string_literal: true

require 'pathname'
require 'fileutils'
include FileUtils

# path to your application root.
APP_ROOT = Pathname.new File.expand_path('../../', __FILE__)

def system!(*args)
  system(*args) || abort("\n== Command #{args} failed ==")
end

def install_dependencies
  chdir APP_ROOT do
    puts '== Installing dependencies =='
    system! 'gem install bundler --conservative'
    system('bundle check') || system!('bundle install')
    yield
  end
end
