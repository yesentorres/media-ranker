class WorksController < ApplicationController

  before_action :find_work, only: [:show, :edit, :update, :destroy, :upvote]

  def main
    @works = Work.all
  end 

  def index
    @works = Work.all
  end

  def show
    if @work.nil?
      render_not_found
      return
    end
  end

  def new
    @work = Work.new
  end 

  def create
    @work = Work.new(work_params) 

    if @work.save
      flash[:success] = "Successfully created #{@work.category} #{@work.id}"
      redirect_to work_path(@work.id)
      return
    else 
      flash.now[:error] = "A problem occured: Could not create #{@work.category}"
      render :new 
      return
    end
  end

  def edit
    if @work.nil?
      render_not_found
      return
    end
  end

  def update
    if @work.nil?
      render_not_found
      return
    elsif @work.update(work_params)
      flash[:success] = "Successfully updated #{@work.category} #{@work.id}"
      redirect_to work_path(@work.id)
      return
    else 
      flash.now[:error] = "A problem occured: Could not update #{@work.category}"
      render :edit 
      return
    end
  end

  def destroy
    if @work.nil?
      render_not_found
      return
    end 

    @work.destroy
    flash[:success] = "Successfully destroyed #{@work.category} #{@work.id}"
    redirect_to root_path
    return
  end

  def upvote
    if session[:user_id].nil?
      flash[:error] = "A problem occured: You must log in to do that"
      redirect_back fallback_location: work_path(@work)
      return
    else 
      @vote = Vote.create(user_id: session[:user_id], work_id: @work.id)

      if @vote.save
        flash[:success] = "Successfully upvoted!"
        redirect_back fallback_location: work_path(@work)
        return 
      else 
        flash.now[:error] = "A problem occured: Could not upvote"
        # create instance variable to pass the vote errors to the views
        @invalid_vote_message = @vote.errors.messages

        render :show
        return
      end
    end 
  end 

end

private

def find_work
  @work = Work.find_by(id: params[:id])
end 

def work_params
  return params.require(:work).permit(:category, :title, :creator, :publication_year, :description)
end
