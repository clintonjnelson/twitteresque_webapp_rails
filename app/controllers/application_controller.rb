class ApplicationController < ActionController::Base
  protect_from_forgery
  include SessionsHelper  # Make available to the Controllers for signin
end
