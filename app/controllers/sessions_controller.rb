class SessionsController < ApplicationController
  def new
  end

  def create
    user = User.find_by(email: params[:email])    
    if user&.authenticate(params[:password])      
      session[:user_id] = user.id
      user.update(login_count: 0)
      user.update(locked: false)
      flash.now.alert = 'Logged in'
      render :new
    else            
      if user 
        session.delete(:user_id)
        if user.locked
          flash.now.alert = 'User locked, contact the admin'
          render :new
        end
        user.login_count = (user.login_count || 1) + 1
        user.save
        if user.login_count >= 3
          user.update(locked: true)
          flash.now.alert = 'User locked'          
        else
          flash.now.alert = 'Email or password is invalid'            
        end                
      else
        flash.now.alert = 'Email or password is invalid'
        render :new
      end      
    end    
  end

  def destroy
    session.delete(:user_id)
    redirect_to '/', notice: 'Logged out!'
  end
end