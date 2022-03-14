class ReadingsController < ApplicationController

  def index
    @readings = Reading.todays_readings.includes(:user)
  end

  def create
    reading = Reading.new(reading_params)
    if reading.save
      redirect_to user_path(reading.user)
    else
      redirect_to user_path(reading.user)
    end
  end

  def update
    reading = Reading.find(params[:id])
    if reading.update(reading_params)
      redirect_to user_url(reading.user)
    else
      redirect_to user_url(reading.user)
    end
  end

  private
  def reading_params
    params.require(:reading).permit(:reading, :user_id)
  end

  def response_attributes
    { only: [:date, :reading, :user_id], include: { :user => { only: [:id, :name, :email, :phone] } } }
  end
end
