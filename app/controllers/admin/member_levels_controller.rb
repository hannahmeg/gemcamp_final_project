class Admin::MemberLevelsController < AdminController
  before_action :set_member_level, only: [:edit, :update, :destroy]

  def index
    @member_levels = MemberLevel.all.page(params[:page]).per(5)
  end

  def new
    @member_level = MemberLevel.new
    @next_level = MemberLevel.last.level + 1
  end

  def create
    highest_level = MemberLevel.maximum(:level) || 0
    new_level = highest_level + 1
    @member_level = MemberLevel.new(member_level_params.merge(level: new_level))
    # @member_level = MemberLevel.new(level: new_level, required_members: params[:required_members], coins: params[:coins])
    if @member_level.save
      redirect_to admin_member_levels_path, notice: 'Member Level was successfully created.'
    else
      render :new
    end
  end

  def edit; end

  def update
    if @member_level.update(member_level_params)
      redirect_to admin_member_levels_path, notice: 'Member Level was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @member_level.destroy
      flash[:notice] = 'Member Level destroyed successfully'
    else
      flash[:alert] = @member_level.errors.full_messages.join(', ')
    end
    redirect_to admin_member_levels_path
  end

  private

  def set_member_level
    @member_level = MemberLevel.find(params[:id])
  end

  def member_level_params
    params.require(:member_level).permit(:required_members, :coins)
  end
end
