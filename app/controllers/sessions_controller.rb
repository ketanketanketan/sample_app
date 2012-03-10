class SessionsController < ApplicationController
  
  def new
    @title = "Sign in"
  end

  def create
    user = User.authenticate(params[:session][:email],
                             params[:session][:password])               
    if user.nil?
      flash.now[:error] = "Invalid email/password combination"
      @title = "Sign in"
      render 'new'
    else
      sign_in user
      redirect_back_or user
    end
    
    @user = User.new(params[:user])
    if @user.save
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      @title = "Sign Up"
      @user.password = @user.password_confirmation = ""
      render 'new'
    end
    
  end
  
  def destroy
    sign_out
    redirect_to root_path
  end

end
