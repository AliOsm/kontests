class SuggestsController < ApplicationController
  http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD'], only: [:index]

  def index
    @suggests = Suggest.order_by_id
  end

  def create
    @suggest = Suggest.new(suggest_params)
    save_process_response
  end

  private

  def suggest_params
    params.require(:suggest).permit(:site, :email, :message)
  end

  def save_process_response
    if @suggest.save
      flash[:notice] =  t(:suggestion_saved)
    else
      flash[:alert] = t(:something_went_wrong)
    end
    redirect_to rooth_path
  end
end
