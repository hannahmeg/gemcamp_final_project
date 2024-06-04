class Client::RegistrationsController < Devise::RegistrationsController
  before_action :configure_sign_up_params, only: [:create]
  before_action :configure_account_update_params, only: [:update]
  layout 'client'

  def new
    cookies[:promoter] = params[:promoter] if params[:promoter].present?
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    @user.parent_id = User.find_by(email: cookies[:promoter])&.id if cookies[:promoter].present?

    if @user.save
      parent = User.find_by(email: cookies[:promoter])
      if parent
        parent.increment!(:children_members)
        next_level_count = parent.member_level.level + 1
        next_level = MemberLevel.find_by(level: next_level_count)

        if parent.children_members == next_level.required_members
          parent.update!(member_level: next_level)
          @order = parent.orders.new(user_id: parent.id, coin: parent.member_level.coins, genre: :member_level, remarks: 'Member Level Reward')
          if @order.save
            @order.submit!
          end
          cookies.delete(:promoter)
        end
      end
      sign_in :user, @user
      redirect_to client_root_path, notice: 'Registration successful!'
    else
      flash.now[:alert] = 'Registration failed'
      render :new
    end
  end

  private

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :username, :phone_number, :password, :image])
  end

  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: [:email, :username, :phone_number, :password, :image])
  end

  private

  def user_params
    params.require(:user).permit(:email, :username, :phone_number, :password, :password_confirmation, :image)
  end
end
