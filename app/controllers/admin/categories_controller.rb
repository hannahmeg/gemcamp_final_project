class Admin::CategoriesController < AdminController
  before_action :set_category, only: [:edit, :update, :destroy]

  def index
    @categories = Category.all.page(params[:page]).per(5).order(:sort)
  end

  def new
    @category = Category.new
  end

  def create
    last_sort_number = Category.maximum(:sort)
    new_sort_number = last_sort_number ? last_sort_number + 1 : 1
    @category = Category.new(category_params.merge(sort: new_sort_number))
    if @category.save
      redirect_to admin_categories_path, notice: 'Category was successfully created.'
    else
      flash.now[:alert] = 'Failed to create category.'
      render :new
    end
  end

  def edit; end

  def update
    if @category.update(category_params)
      redirect_to admin_categories_path, notice: 'Category was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    if @category.destroy
      flash[:notice] = 'Category destroyed successfully'
    else
      flash[:alert] = @category.errors.full_messages.join(', ')
    end
    redirect_to admin_categories_path
  end

  private

  def set_category
    @category = Category.find(params[:id])
  end

  def category_params
    params.require(:category).permit(:name, :sort)
  end
end
