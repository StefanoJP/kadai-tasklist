class UsersController < ApplicationController
  #showへのフィルター
  before_action :set_user, only: [:show]
  before_action :correct_user, only: [:show]
  
  def index
  end

  def show
    #@user = User.find(params[:id])
    @tasks = @user.tasks.order('created_at DESC').page(params[:page])
    counts(@user)
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)

    if @user.save
      #ユーザー登録後、トップページへ自動アクセス
      session[:user_id] = @user.id
      flash[:success] = 'ユーザを登録しました。'
      redirect_to root_url
    else
      flash.now[:danger] = 'ユーザの登録に失敗しました。'
      render :new
    end
  end
  
  private
  
  #showへのフィルター
  def set_user
    @user = User.find(params[:id])
  end
  
  #showへのフィルター
  def correct_user
    redirect_to root_url if @user != current_user
  end

  def user_params
    params.require(:user).permit(:name, :email, :password, :password_confirmation)
  end
end
