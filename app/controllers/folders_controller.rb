# frozen_string_literal: true

class FoldersController < ApplicationController
  before_action :authenticate_user!

  def index
    folders = Folder.includes(:children)
    render json: folders
  end

  def create
    folder = Folder.create(folder_params)
    render json: folder
  end

  private

  def folder_params
    params.require(:folder).permit(:name, :parent_id)
  end
end
