class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  

  protected
  # Redirects to holiday path after sign in (inc. protected part above)
  def after_sign_in_path_for(resource)
    holidays_path
  end

end
