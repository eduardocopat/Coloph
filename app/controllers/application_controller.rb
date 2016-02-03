class ApplicationController < ActionController::Base
  protect_from_forgery

  # TODO We have to set CRSF tokens  =) http://stackoverflow.com/questions/7203304/warning-cant-verify-csrf-token-authenticity-rails
  skip_before_filter :verify_authenticity_token
end
