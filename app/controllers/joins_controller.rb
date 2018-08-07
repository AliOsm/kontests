class JoinsController < ApplicationController
  http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD'], only: [:index]

  def index
    @joins = Join.order_by_id
  end

  def create
    @join = Join.new(join_params)
    save_process_response
  end

  private

  def join_params
    params.require(:join).permit(:name, :email, :how)
  end

  def save_process_response
    if @join.save
      flash[:notice] = t(:success_join_request)
    else
      flash[:alert] = t(:something_went_wrong)
    end
    redirect_to root_path
  end
end
