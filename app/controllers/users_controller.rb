class UsersController < ApplicationController

  def index
    @users = User.all
  end

  def show
    @user = User.find params[:id]
    @options = [
      {'label' => "Daily", 'value' => 'daily'},
      {'label' => "Monthly", 'value' => 'monthly'},
      {'label' => "From Date", 'value' => 'from_date'}
    ]
    @readings = @user.get_report params
    @todays_readings = @user.todays_readings
  end

  def create
    user = User.new(user_params)
    if user.save
      redirect_to user
    else
      render json: user.to_json(
        methods: [ :error_messages ]
      )
    end
  end

  def update
    user = User.find params[:id]
    if user.update(user_params)
      redirect_to user
    else
      render json: user.to_json(
        methods: [ :error_messages ]
      )
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :phone)
  end

  def response_attributes
    {
      only: [ :name, :email, :phone, :id ],
      include: {
        readings: {
          only: [:date, :reading]
        }
      }
    }
  end
end
