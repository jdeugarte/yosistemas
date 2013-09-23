class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  helper_method :current_user
  before_filter :require_log_in  

  private
  
  def current_user
    @current_user ||= Usuario.find(session[:usuario_id]) if session[:usuario_id]
  end
  
  def require_log_in
    unless current_user
      redirect_to log_in_path
    end
  end
end
