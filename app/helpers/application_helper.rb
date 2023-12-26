module ApplicationHelper

  def current_user
    # method to get session of user id to see if logged in
    # if no session, will return nil, therefore the conditional
    # check
    # We can optimize the current_user method by storing the result 
    # of calling User.find in an instance variable, and only running 
    # the query again if that instance variable doesn't already have a value. 
    # To do that, change the current_user method to set a 
    # @current_user instance variable using the ||= operator
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end

end
