class WelcomeController < ApplicationController
  skip_before_filter :require_log_in
  def index
  end
end
