class ProjectsController < ApplicationController

  before_action :target_project, except: [:new, :create, :index]
  before_action :authenticate_user
  before_action :project_member_authorization, except: [:new, :create, :index]

  def index
    @projects = Project.all

  end

  def new
    @project = Project.new
  end

  def create
    @project = Project.new(project_params)
    if @project.save
      ProjectManagement.assign_current_user_as_project_owner(@project, current_user)
      flash[:success] = "Project was successfully created"
      redirect_to project_tasks_path(@project)
    else
      render :new
    end
  end

  def show
  end

  def edit
  end

  def update
    if @project.update(project_params)
      flash[:success] = "Project was successfully updated"
      redirect_to projects_path
    else
      render :edit
    end
  end

  def destroy
    if @project.destroy
      flash[:success] = "Project was successfully deleted"
      redirect_to projects_path
    else
      render :edit
    end
  end

  private

    def project_params
      params.require(:project).permit(:name)
    end

    def project_member_authorization
      unless current_user.project_member_verify(@project)
        flash[:danger] = 'You do not have access to that project'
        redirect_to projects_path
      end
    end

    def target_project
      @project = Project.find(params[:id])
    end

end
