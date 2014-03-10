class BudgetsController < ApplicationController
  before_action :signed_in_user, only: [:create]

  def index
  end

  def new    
    session[:budget_params] ||= {}
    @budget = Budget.new(session[:budget_params])
    @budget.current_step = session[:budget_step]
  end

  def create
    session[:budget_params].deep_merge!(params[:budget]) if params[:budget]
    @budget = Budget.new(session[:budget_params])
    @budget.current_step = session[:budget_step]
    if @budget.valid?
      if params[:back_button]
        @budget.previous_step
      elsif @budget.last_step? 
        if current_user.nil? == false      
          @budget.save
          current_user.update_attribute(:budget_id, @budget.id)          
        end
      else
        @budget.next_step
      end
      session[:budget_step] = @budget.current_step
    end
    if @budget.new_record?
      render 'new'
    else
      session[:budget_step] = session[:budget_params] = nil
      flash[:success] = "Budget created!"
      redirect_to root_url
    end  
  end

  def show
    @budget = Budget.find(params[:id])
  end

  private

    def budget_params
      params.require(:budget).permit(:name, :description, :allowance, :start_date)
    end
end