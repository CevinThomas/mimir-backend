# frozen_string_literal: true

class FoldersController < ApplicationController
  before_action :authenticate_user!

  def index
    return render json: { folders: [] } unless current_user.role == 'admin'

    folders = Folder.includes(:children).where(account_id: current_user.account_id).reject do |folder|
      folder.name == 'Uncategorized'
    end
    render json: folders
  end

  def create
    # TODO: Check if user is Admin
    folder = Folder.new(folder_params)
    folder.account = current_user.account
    folder.save!
    render json: folder
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end
end
