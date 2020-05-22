class WorksController < ApplicationController

  def main
    @works = Work.all
  end 

  def index
    @works = Work.all
  end

  def show
    @work = Work.find_by(id: params[:id])

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
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      render_not_found
      return
    end
  end

  def update
    @work = Work.find_by(id: params[:id])

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
    @work = Work.find_by(id: params[:id])

    if @work.nil?
      render_not_found
      return
    end 

    @work.destroy
    flash[:success] = "Successfully destroyed #{@work.category} #{@work.id}"
    redirect_to root_path
    return
  end

end

private

def work_params
  return params.require(:work).permit(:category, :title, :creator, :publication_year, :description, vote_ids: [])
end
