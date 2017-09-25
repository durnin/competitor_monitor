# frozen_string_literal: true

# A sample Guardfile
# More info at https://github.com/guard/guard#readme

## Uncomment and set this to only include directories you want to watch
# directories %w(app lib config test spec features) \
#  .select{|d| Dir.exists?(d) ? d : UI.warning("Directory #{d} does not exist")}

## Note: if you are using the `directories` clause above and you are not
## watching the project directory ('.'), then you will want to move
## the Guardfile to a watched dir and symlink it back, e.g.
#
#  $ mkdir config
#  $ mv Guardfile config/
#  $ ln -s config/Guardfile .
#
# and, you'll have to watch "config/Guardfile" instead of "Guardfile"

# Detect violations to ruby style guidelines
guard :rubocop do
  watch(/.+\.rb$/)
  watch(%r{(?:.+/)?\.rubocop(?:_todo)?\.yml$}) { |m| File.dirname(m[0]) }
end

# Note: The cmd option is now required due to the increasing number of ways
#       rspec may be run, below are examples of the most common uses.
#  * bundler: 'bundle exec rspec'
#  * bundler binstubs: 'bin/rspec'
#  * spring: 'bin/rspec' (This will use spring if running and you have
#                          installed the spring binstubs per the docs)
#  * zeus: 'zeus rspec' (requires the server to be started separately)
#  * 'just' rspec: 'rspec'

# Class for guard-rspec definitions
class GuardRSpec
  require 'guard/rspec/dsl'

  def initialize(guard_dsl)
    @guard_dsl = guard_dsl
    @dsl = Guard::RSpec::Dsl.new(@guard_dsl)
    @rspec = @dsl.rspec
    @ruby = @dsl.ruby
    @rails = @dsl.rails(view_extensions: %w[erb haml slim])
  end

  def guard_all
    @guard_dsl.guard :rspec, cmd: 'bundle exec rspec' do
      # RSpec files
      rspec_files
      # Ruby files
      ruby_files
      # Rails files
      rails_files
      # Rails controllers
      rails_controllers
      # Rails config changes
      rails_config
      # Capybara features specs
      capybara
      # Turnip features and steps
      turnip
    end
  end

  private

  def rspec_files
    @guard_dsl.watch(@rspec.spec_helper) { @rspec.spec_dir }
    @guard_dsl.watch(@rspec.spec_support) { @rspec.spec_dir }
    @guard_dsl.watch(@rspec.spec_files)
  end

  def ruby_files
    @dsl.watch_spec_files_for(@ruby.lib_files)
  end

  def rails_files
    @dsl.watch_spec_files_for(@rails.app_files)
    @dsl.watch_spec_files_for(@rails.views)
  end

  def rails_controllers
    @guard_dsl.watch(@rails.controllers) do |m|
      [
        @rspec.spec.call("routing/#{m[1]}_routing"),
        @rspec.spec.call("controllers/#{m[1]}_controller"),
        @rspec.spec.call("acceptance/#{m[1]}")
      ]
    end
  end

  def rails_config
    @guard_dsl.watch(@rails.spec_helper)   { @rspec.spec_dir }
    @guard_dsl.watch(@rails.routes)        { "#{@rspec.spec_dir}/routing" }
    @guard_dsl.watch(@rails.app_controller) do
      "#{@rspec.spec_dir}/controllers"
    end
  end

  def capybara
    @guard_dsl.watch(@rails.view_dirs) do |m|
      @rspec.spec.call("features/#{m[1]}")
    end
    @guard_dsl.watch(@rails.layouts) do |m|
      @rspec.spec.call("features/#{m[1]}")
    end
  end

  def turnip
    @guard_dsl.watch(%r{^spec/acceptance/(.+)\.feature$})
    @guard_dsl.watch(%r{^spec/acceptance/steps/(.+)_steps\.rb$}) do |m|
      Dir[File.join("**/#{m[1]}.feature")][0] || 'spec/acceptance'
    end
  end
end

GuardRSpec.new(self).guard_all

# Detect code smells after updating ruby file
guard 'reek' do
  watch(/.+\.rb$/)
  watch('.reek')
end

# Lint CoffeeScript files on change
guard :coffeelint do
  watch %r{^app/assets/javascripts/.*\.coffee$}
end
