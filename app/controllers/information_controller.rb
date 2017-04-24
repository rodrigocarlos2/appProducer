
#!/usr/bin/env ruby
# encoding: utf-8

require "bunny"

class InformationController < ApplicationController
  before_action :set_information, only: [:show, :edit, :update, :destroy]

  # GET /information
  # GET /information.json
  def index
    @information = Information.all
  end

  # GET /information/new
  def new
    @information = Information.new
  end

  # POST /information
  # POST /information.json
  def create
    @information = Information.new(information_params)

    respond_to do |format|
      
      if @information.save

        conn = Bunny.new(:automatically_recover => false)
        conn.start

        ch = conn.create_channel
        q = ch.queue("user")

        ch.default_exchange.publish(@information.content, :routing_key => q.name)

        conn.close

        format.html { redirect_to @information, notice: 'Information was successfully created.' }
        format.json { render :show, status: :created, location: @information }
      else
        format.html { render :new }
        format.json { render json: @information.errors, status: :unprocessable_entity }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_information
      @information = Information.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def information_params
      params.require(:information).permit(:content)
    end
end
