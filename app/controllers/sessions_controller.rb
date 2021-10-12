class SessionsController < ApplicationController
  skip_before_action :authorized, only: [:new, :create, :welcome, :signup, :register]

  def new
    if session[:user_id]
      redirect_to root_url
    end
  end

  def create
    user = User.find_by_email(params[:email])
    user_by_username = User.where(username: params[:email]).first
    remember_me = params["remember_me"]
    if user && user.authenticate(params[:password])
      session[:user_id] = user.id

      if params["remember_me"]
        cookies[:user_id] = user.id
      else
        cookies[:user_id] = nil
      end

     
      redirect_to root_url
    elsif user_by_username && user_by_username.authenticate(params[:password])
      session[:user_id] = user_by_username.id

      if params["remember_me"]
        cookies[:user_id] = user_by_username.id
      else
        cookies[:user_id] = nil
      end

      redirect_to root_url
    else
      flash.now[:alert] = "Username / Email or password is invalid"
      render "new"
    end
  end

  def signup
    if session[:user_id]
      redirect_to root_url
    end
    @user = User.new
  end

  def register
    #fix
    role_admin = Role.where(name: "Admin")
    @user = User.new(user_params)
    if @user.valid?
      @user.email_confirm = 0
      @user.phone_confirm = 0
      @user.is_active = 0
      @user.groups = "User"
      @user.roles = role_admin
      @user.save
      flash[:success] = "Your account has been created. You can now login."
      redirect_to login_path
    else
      flash.now[:register] = "Validation error"
      render :signup
    end
  end

  def destroy
    session[:user_id] = nil
    cookies[:user_id] = nil
    redirect_to root_url
  end

  private
    def user_params
      params.permit(:username, :email, :password, :password_confirmation)
    end

end