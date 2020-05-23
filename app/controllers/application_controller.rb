class ApplicationController < ActionController::Base

  # render the error page provided by rails for all 404 errors
  def render_not_found
    render :file => "#{Rails.root}/public/404.html",  :status => 404
  end

end
