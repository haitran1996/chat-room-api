class Api::V1::UsersController < ApplicationController
  def index
    @users = User.where('name like ?', "%#{params[:name]}%")
  end

  def show
    @user = User.find(params[:id])
  end

  def update
    @user = current_user
    if @user.update(update_params)
      render_json(data: @user, status: 200)
    else
      render_json(status: 422, errors: @user.errors.full_messages)
    end
  end

  private

  def update_params
    params.permit(:name, :image, :description)
  end

  def user_params
    params.permit(*User::PERMITTED_ATTRIBUTES)
  end
end
