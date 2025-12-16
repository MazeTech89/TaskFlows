# Priorities controller - manages CRUD operations for priority levels
class PrioritiesController < ApplicationController
  before_action :set_priority, only: %i[show edit update destroy]

  # GET /priorities - list all priorities
  def index
    @priorities = Priority.all
    respond_to do |format|
      format.html
      format.json { render json: @priorities }
    end
  end

  # GET /priorities/:id - show single priority
  def show
    respond_to do |format|
      format.html
      format.json { render json: @priority }
    end
  end

  # POST /priorities - create new priority
  def create
    @priority = Priority.new(priority_params)

    if @priority.save
      respond_to do |format|
        format.html { redirect_to @priority, notice: "Priority created." }
        format.json { render json: @priority, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @priority.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /priorities/:id - update priority
  def update
    if @priority.update(priority_params)
      respond_to do |format|
        format.html { redirect_to @priority, notice: "Priority updated." }
        format.json { render json: @priority }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @priority.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /priorities/:id - delete priority
  def destroy
    @priority.destroy
    respond_to do |format|
      format.html { redirect_to priorities_url, notice: "Priority destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Find priority by ID, return 404 if not found
  def set_priority
    @priority = Priority.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  # Permitted parameters for security (prevents mass assignment attacks)
  def priority_params
    params.require(:priority).permit(:name, :score)
  end
end
