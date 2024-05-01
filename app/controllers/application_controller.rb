class ApplicationController < ActionController::Base


  private
  def after_sign_in_path_for(resource)
    if resource.client?
      client_root_path
    elsif resource.admin?
      admin_root_path
    else
      root_path
    end
  end
end
