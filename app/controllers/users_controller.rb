class UsersController < ApplicationController

  before_action :require_signin, except: [:new, :create]
  before_action :require_correct_user, only: [:edit, :update]
  before_action :require_admin, only: [:destroy]
  before_action :set_user, only: [:show, :destroy]

  def index
    @users = User.not_admins
  end

  def show
    @reviews = @user.reviews
    @favorite_movies = @user.favorite_movies
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thanks for signing up!"
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to @user, notice: "Account successfully updated!"
    else
      render :new
    end
  end

  def destroy
    if @user.destroy
      if current_user?(@user)
        session[:user_id] = nil
      end
      redirect_to users_path, alert: "Account successfully deleted!"
    end
  end

  private

  def set_user
    @user = User.find_by!(slug: params[:id])
  end

  def require_correct_user
    @user = User.find_by!(slug: params[:id])
    redirect_to root_path, alert: "Unauthorized!" unless current_user?(@user)
  end

  def user_params
    params
      .require(:user)
      .permit(:name, :email, :password, :password_confirmation)
  end

end
