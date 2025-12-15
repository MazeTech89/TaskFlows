class PrioritiesController < ApplicationController
  before_action :set_priority, only: %i[show edit update destroy]

  def index
    @priorities = Priority.all
    respond_to do |format|
      format.html
      format.json { render json: @priorities }
    end
  end

  def show
    respond_to do |format|
      format.html
      format.json { render json: @priority }
    end
  end

  def create
    @priority = Priority.new(priority_params)
    if @priority.save
      respond_to do |format|
        format.html { redirect_to @priority, notice: 'Priority created.' }
        format.json { render json: @priority, status: :created }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @priority.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    if @priority.update(priority_params)
      respond_to do |format|
        format.html { redirect_to @priority, notice: 'Priority updated.' }
        format.json { render json: @priority }
      end
    else
      respond_to do |format|
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @priority.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @priority.destroy
    respond_to do |format|
      format.html { redirect_to priorities_url, notice: 'Priority destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_priority
    @priority = Priority.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    head :not_found
  end

  def priority_params
    params.require(:priority).permit(:name, :score)
  end
end
