class FilesController < ApplicationController
  def file_upload; end

  def upload
    Files::ProcessFile.call(params[:file], current_user.id)

    redirect_to user_summary_path, notice: 'File uploaded succesfully.'
  rescue StandardError
    redirect_to user_summary_path, notice: 'File not uploaded'
  end
end
