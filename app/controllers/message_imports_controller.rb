class MessageImportsController < ApplicationController
  def new
    @message_import = MessageImport.new
  end

  def create
    @message_import = MessageImport.new(params[:message_import])
    if @message_import.save
      redirect_to root_url, notice: "Imported messages successfully."
    else
      render :new
    end
  end
end
