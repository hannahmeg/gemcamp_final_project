class AdminController < ApplicationController
  layout 'admin'
  def index
    unless user_signed_in?
      redirect_to new_admin_session_path
    end
  end
end



