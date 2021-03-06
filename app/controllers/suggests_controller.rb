class SuggestsController < ApplicationController
  before_action :logged_in_user, :suggest_by_user, only: :index
  before_action :load_suggest, only: %i(destroy index)

  def index; end

  def new
    @suggest = current_user.suggests.build
  end

  def create
    @suggest = Suggest.new suggest_params
    if @suggest.save
      flash[:success] = t ".success_rq"
      redirect_to suggests_path(user_id: current_user)
    else
      flash.now[:danger] = t "can't_rq"
      render :new
    end
  end

  def destroy
    if @suggest.destroy
      flash[:success] = t "deleted"
      redirect_to suggests_path(user_id: current_user)
    else
      flash[:danger] = t "un_delete"
      redirect_to root_path
    end
  end

  private

  def suggest_params
    params.require(:suggest).permit :user_id, :title,
     :content, :author, :categories
  end

  def load_suggest
    @suggest = Suggest.find_by id: params[:id]
    return if @suggest
    flash[:danger] = t "controller.no_data_rq"
    redirect_to root_path
  end

  def suggest_by_user
    @suggests = current_user.suggests.newest.by_suggest params[:user_id]
  end

  def logged_in_user
    return if logged_in?
    store_location
    flash[:danger] = t "controller.book.please_login"
    redirect_to login_path
  end
end
