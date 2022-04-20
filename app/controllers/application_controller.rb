class ApplicationController < ActionController::Base
  include Clearance::Controller

  before_action :require_login

  def require_ownership(article_params)
    unless current_user.is_author?(Article.find(article_params))
      redirect_to root_path
    end
  end
end
