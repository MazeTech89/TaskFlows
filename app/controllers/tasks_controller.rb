# Tasks controller - manages tasks with filtering and search capabilities
class TasksController < ApplicationController
  before_action :set_task, only: %i[ show edit update destroy ]

  # GET /tasks - list all tasks with optional filters
  def index
    # Load tasks for current user's projects
    @tasks = Task.includes(:project, :priority)
                 .joins(:project)
                 .where(projects: { user_id: current_user.id })
    
    # Apply filters from query params
    @tasks = @tasks.by_project(params[:project_id]) if params[:project_id].present?
    @tasks = @tasks.by_priority(params[:priority_id]) if params[:priority_id].present?
    @tasks = @tasks.by_completion_status(params[:status]) if params[:status].present?
    
    # Search by name (case-insensitive)
    if params[:search].present?
      @tasks = @tasks.where('tasks.name ILIKE ?', "%#{params[:search]}%")
    end
    
    # Filter by due date
    if params[:due_date].present?
      @tasks = @tasks.where(due_date: params[:due_date])
    end
    
    @tasks = @tasks.order(created_at: :desc)
  end

  # GET /tasks/1 - show single task
  def show
  end

  # GET /tasks/new - new task form (optionally within a project context)
  def new
    @project = params[:project_id].present? ? current_user.projects.find(params[:project_id]) : current_user.projects.first
    @task = Task.new
    @task.project_id = @project&.id
  end

  # GET /tasks/1/edit - edit task form
  def edit
    @project = @task.project
  end

  # POST /tasks - create new task
  def create
    @task = Task.new(task_params)
    @project = @task.project

    respond_to do |format|
      if @task.save
        format.html { redirect_to @task, notice: "Task was successfully created." }
        format.json { render :show, status: :created, location: @task }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /tasks/1 - update task
  def update
    respond_to do |format|
      if @task.update(task_params)
        format.html { redirect_to @task, notice: "Task was successfully updated.", status: :see_other }
        format.json { render :show, status: :ok, location: @task }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @task.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /tasks/1 - delete task
  def destroy
    @task.destroy!

    respond_to do |format|
      format.html { redirect_to tasks_path, notice: "Task was successfully destroyed.", status: :see_other }
      format.json { head :no_content }
    end
  end

  private
    # Find task scoped to current user's projects
    def set_task
      @task = Task.joins(:project)
                  .where(projects: { user_id: current_user.id })
                  .find(params.expect(:id))
    end

    # Permitted parameters for security
    def task_params
      params.expect(task: [ :name, :due_date, :completed, :project_id, :priority_id ])
    end
end
