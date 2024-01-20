class Api::V1::UsersController < ApplicationController
  def index
    @users = User.where('name like ?', "%#{params[:name]}%")
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = current_user
    if @user.update(user_params)
      render json: { data: @user }, status: :ok
    else
      render json: { errors: @user.errors }, status: :unprocessable_entity
    end
  end

  private

  def user_params
    params.permit(*User::PERMITTED_ATTRIBUTES)
  end
end
