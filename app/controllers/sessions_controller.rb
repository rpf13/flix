class SessionsController < ApplicationController
  def new

  end

  def create
    user = User.find_by(email: params[:email_or_username]) ||
            User.find_by(username: params[:email_or_username])
    # user can be found either by mail or username. In params
    # hash, the key :email_or_useranme relates directly to the
    # form label (sessions new.html.erb)

    if user && user.authenticate(params[:password])
      # check if user is true / exists and if so, pass the
      # password out of the submitted form to the authenticate
      # method, which will hash it and compare to the stored

      session[:user_id] = user.id
      # if user is authenticated, session id is created and we use
      # the user id value and assign it to the user_id key of the

      redirect_to user, notice: "Welcome back, #{user.name}!"
    else
      flash.now[:alert] = "invalid email/password combination!"
      # flash.now makes the flash message available in the same 
      # request rather than waiting for the next request.
      
      render :new, status: :unprocessable_entity
    end
  end

  def destroy

  end
end