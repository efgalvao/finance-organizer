class FilesController < ApplicationController
  def file_upload; end

  def upload
    Files::ProcessFile.call(params[:file], current_user.id)
  end
end
