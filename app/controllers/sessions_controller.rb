class SessionsController < ApplicationController

  def new
  end

  def create
    @user = User.find_by_name(params[:name])
    logger.info params
    if @user && @user.authenticate(params[:password])
      sign_in @user
      redirect_to root_url, notice: "Signed in successfully."
    else
      flash.now.alert = "Email or password is invalid"
      render :new
    end
  end

  def destroy
    session[:remember_token] = nil
    redirect_to root_url, notice: "You are signed out."
  end
end
