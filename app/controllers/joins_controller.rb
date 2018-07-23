class JoinsController < ApplicationController
  http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD'], only: [:index]

  def index
    @joins = Join.all.order(id: :desc)
  end

  def create
    @join = Join.new(join_params)
    
    respond_to do |format|
      if @join.save
        format.html { redirect_to root_path, notice: 'Thank you! and we will review your join request as soon as possible.' }
      else
        format.html { redirect_to root_path, alert: 'Check your inputs please.' }
      end
    end
  end
  
  private
  
  def join_params
    params.require(:join).permit(:name, :email, :how)
  end
end
