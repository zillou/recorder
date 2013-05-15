class MessagesController < ApplicationController
  before_filter :authorize
  def index
    @messages = Message.all

    respond_to do |format|
      format.html
      format.csv
      format.xls
    end
  end

  def show
    @message = Message.find(params[:id])
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(params[:message])

    if @message.save
      logger.info "Pre message's date: #{@message.date}"
      session[:pre_date] = @message.date

      redirect_to new_message_path, notice: "#{@message.to_s} created successfully."
    else
      render :new
    end
  end

  def edit
    @message = Message.find(params[:id])
  end

  def update
    @message = Message.find(params[:id])

    if @message.update_attributes(params[:message])
      redirect_to messages_path, notice: "Message updated."
    else
      render :edit
    end
  end

  def import
    Product.import(params[:file])
    redirect_to root_url, notice: "imported"
  end
end
