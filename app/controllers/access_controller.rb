class AccessController < ApplicationController
  skip_before_action :authorize

  def new
    if session[:user_id]
      redirect_to admin_url, notice: "You've Already Logged In. "
      return
    end 
  end

  # Post '/login'
  def create
    user = User.find_by(username: params[:username])

    if user and user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to admin_url, notice: "You've Logged In Successfully ! "
    else
      redirect_to login_url, alert: "Invalid Username or Password. Please Try Again ! "
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to shopper_url, notice: "You've Logged Out Successfully ! "
  end
end
