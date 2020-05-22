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

end

private

def user_params
  return params.require(:user).permit(:name)
end

