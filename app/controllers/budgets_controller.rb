class BudgetsController < ApplicationController
  before_action :signed_in_user, only: [:create]

  def index
  end

  def new    
    @budget = Budget.new
  end

  def create
    @budget = Budget.new(budget_params)
    if(@budget.save)
      flash[:success] = "Save success!"
      current_user.budget_id = @budget.id
      current_user.save
      redirect_to current_user
    else
      render 'new'
    end     
  end

  def show
    @budget = Budget.find(params[:id])
  end

  private

    def budget_params
      params.require(:budget).permit(:name, :description, :allowance)
    end
end