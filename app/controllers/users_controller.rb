class UsersController < ApplicationController

  before_action :require_signin, except: [:new, :create]
  # Authorization -  before_action to call require_signin method (which
  # is defined in ApplicationController) before running any action 
  # except new or create.

  before_action :require_correct_user, only: [:edit, :update, :destroy]
  # a signed-in user should only be allowed to edit or delete their own account
  # The require_correct_user method is defined in the users controller

  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to @user, notice: "Thanks for singing up!"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    # since the require_correct_user method is run before this one,
    # search of the user object in params hash no longer required.
    # @user = User.find(params[:id])
  end

  def update
    # since the require_correct_user method is run before this one,
    # search of the user object in params hash no longer required.
    # @user = User.find(params[:id])
    if @user.update(user_params)
      redirect_to @user, notice: "Account successfully updated!"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    # since the require_correct_user method is run before this one,
    # search of the user object in params hash no longer required.
    # @user = User.find(params[:id])
    @user.destroy
    session[:user_id] = nil
    redirect_to movies_url, status: :see_other,
      alert: "Account successfully deleted!"    
  end

end

private

def user_params
  params.require(:user).
    permit(:name, :username, :email, :password, :password_confirmation)
end

def require_correct_user
  @user = User.find(params[:id])
  redirect_to root_url, status: :see_other unless current_user?(@user)
end
