class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find_by(id: params[:id])

    if @user.nil?
      render_not_found
      return
    end
  end

  def login_form
    @user = User.new 
  end 

  def login 
    username = params[:user][:name] # get the name the user entered
    found_user = User.find_by(name: username) # search for that name in the User table

    if !found_user.nil?
      # an existing user's id gets logged in session
      session[:user_id] = found_user.id
      flash[:success] = "Successfully logged in as existing user #{username}"
    else
      # new user gets created and then logged to session 
      @user = User.create(name: username)

      if @user.save 
        session[:user_id] = @user.id
        flash[:success] = "Successfully created new user #{username} with ID #{@user.id}"
        redirect_to root_path
        return
      else
        flash.now[:error] = "A problem occured: Cout not log in"
        render :login_form
        return
      end 
    end

    redirect_to root_path
    return
  end 

  def logout 
    session[:user_id] = nil
    flash[:success] = "Successfully logged out"

    redirect_to root_path
    return
  end 
  
end

private

def user_params
  return params.require(:user).permit(:name, vote_ids: [])
end

