require 'shortener'
class LinksController < ApplicationController
  include Shortener
  before_action :set_session
  before_action :set_link, only: [:show, :edit, :update, :destroy]

  # GET /links
  # GET /links.json
  def index
    @links = Link.find(session[:links])
  end

  # GET /links/1
  # GET /links/1.json
  def show
  end

  # GET /links/new
  def new
    @link = Link.new
  end

  # GET /links/1/edit
  def edit
  end

  # POST /links
  # POST /links.json
  def create
    @link = Link.new(link_params)
    respond_to do |format|
      if @link.save
        session[:links] << @link.id
        flash[:success] = "Link was successfully created."
        format.html { redirect_to links_url }
        format.json { render :show, status: :created, location: @link }
      else
        format.html { render :new }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /links/1
  # PATCH/PUT /links/1.json
  def update
    respond_to do |format|
      if @link.update(link_params)
        format.html { redirect_to @link, notice: 'Link was successfully updated.' }
        format.json { render :show, status: :ok, location: @link }
      else
        format.html { render :edit }
        format.json { render json: @link.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /links/1
  # DELETE /links/1.json
  def destroy
    session[:links].delete_if{|i| i == @link.id}
    @link.destroy
    respond_to do |format|
      flash[:danger] = "Link was successfully destroyed."
      format.html { redirect_to links_url}
      format.json { head :no_content }
    end
  end

  def go
    id = decode(params[:input_url])
    @link = Link.find(id)
    redirect_to @link.output_url, :status => @link.http_status
  rescue
    redirect_to root_url
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_link
      @link = Link.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def link_params
      params.require(:link).permit(:input_url, :output_url, :http_status)
    end

    def set_session
      session[:links] = session[:links] || []
    end
end
