class FilesController < ApplicationController

  def file_upload

  end

  def upload
    response = Files::ParseFile.call(params[:file])
  end
end
