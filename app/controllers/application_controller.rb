class ApplicationController < ActionController::Base
  include Pundit, Response, Pagination

  skip_before_action :verify_authenticity_token

  rescue_from Pundit::NotAuthorizedError do |exception|
    forbidden_response(exception.message)
  end
end
