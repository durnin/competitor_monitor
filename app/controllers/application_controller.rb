# frozen_string_literal: true

# Rails ApplicationController Class
class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
end
