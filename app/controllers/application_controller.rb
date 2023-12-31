class ApplicationController < ActionController::Base

  private

  def current_user
    # method to get session of user id to see if logged in
    # if no session, will return nil, therefore the conditional check
    # We can optimize the current_user method by storing the result 
    # of calling User.find in an instance variable, and only running 
    # the query again if that instance variable doesn't already have a value. 
    # To do that, change the current_user method to set a 
    # @current_user instance variable using the ||= operator
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

  helper_method :current_user
  # To call the current_user helper method in views (controller application
  # helpers are not accessible from views), we need to declare it as a helper
  # method inside the controller.
  # To declare a method in a controller as also being a helper method,
  # call the helper_method method and pass it the name of the method 
  # (as a symbol) that you want to make accessible as a helper method.

  def current_user?(user)
    # used to check if the signed in user is the user
    current_user == @user
  end

  helper_method :current_user?
  # Helper to make it possible to call from view since
  # by default controller methods are not available in views

  def require_signin
    unless current_user
      session[:intended_url] = request.url
      # in order to remember the url of the requested page we want to
      # access...but got redirected to login first. We want to redirect
      # user to that original requested page after successful login
      redirect_to new_session_url, alert: "Please sign in first!"
    end
  end

  def require_admin
    # check if user is admin, admin flag set true/false if not
    # redirect to root url
    # based on concatenation of current_user_admin? method, which
    # checks if user is logged in and admin
    unless current_user_admin?
      redirect_to root_url, alert: "Unauthorized access!"
    end
  end

  def current_user_admin?
    # check if there is a user at all - logged in
    # and if admin flag is set
    current_user && current_user.admin?
  end

  helper_method :current_user_admin?
  # Helper to make it possible to call from view

end
