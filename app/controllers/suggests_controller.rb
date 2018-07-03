class SuggestsController < ApplicationController
  http_basic_authenticate_with name: ENV['USERNAME'], password: ENV['PASSWORD'], only: [:index]
  
  def index
    @suggests = Suggest.all.order(id: :desc)
  end

  def create
    @suggest = Suggest.new(suggest_params)
    
    respond_to do |format|
      if @suggest.save
        format.html { redirect_to root_path, notice: 'Thank you! and we will review your suggestion as soon as possible.' }
      else
        format.html { redirect_to root_path, alert: 'Check your inputs please.' }
      end
    end
  end
  
  private
  
  def suggest_params
    params.require(:suggest).permit(:site, :email, :message)
  end
end
