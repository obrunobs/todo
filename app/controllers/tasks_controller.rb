class TasksController < ApplicationController
  before_action :set_task, only: %i[ edit update destroy ]

  def index
    @tasks = Task.only_parents.order(:due_date, :description)
  end

  def new
    @task = Task.new
  end

  def edit
  end

  def create
    @task = Task.new(task_params)
      if @task.save
        redirect_to tasks_path, notice: "Task was successfully created."
      else
        flash.now[:alert] = @task.errors.full_messages.to_sentence
        render :new, status: :unprocessable_entity
      end
  end

  def update
      if @task.update(task_params)
        redirect_to tasks_path, notice: "Task was successfully updated."
      else
        flash.now[:alert] = @task.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
  end

  def destroy
    @task.destroy!
      redirect_to tasks_path, status: :see_other, notice: "Task was successfully destroyed."
  end

  private

  def set_task
    @task = Task.find(params.expect(:id))
  end

  def task_params
    params.expect(task: [ :description, :due_date, :done, :parent_id ])
  end
end
