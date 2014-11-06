class HashTagsController < ApplicationController
  before_action :set_hash_tag, only: [:show, :edit, :update, :destroy]

  # GET /hash_tags
  # GET /hash_tags.json
  def index
    @hash_tags = HashTag.all
  end

  # GET /hash_tags/1
  # GET /hash_tags/1.json
  def show
  end

  # GET /hash_tags/new
  def new
    @hash_tag = HashTag.new
  end

  # GET /hash_tags/1/edit
  def edit
  end

  # POST /hash_tags
  # POST /hash_tags.json
  def create
    @hash_tag = HashTag.new(hash_tag_params)

    respond_to do |format|
      if @hash_tag.save
        format.html { redirect_to @hash_tag, notice: 'Hash tag was successfully created.' }
        format.json { render :show, status: :created, location: @hash_tag }
      else
        format.html { render :new }
        format.json { render json: @hash_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /hash_tags/1
  # PATCH/PUT /hash_tags/1.json
  def update
    respond_to do |format|
      if @hash_tag.update(hash_tag_params)
        format.html { redirect_to @hash_tag, notice: 'Hash tag was successfully updated.' }
        format.json { render :show, status: :ok, location: @hash_tag }
      else
        format.html { render :edit }
        format.json { render json: @hash_tag.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /hash_tags/1
  # DELETE /hash_tags/1.json
  def destroy
    @hash_tag.destroy
    respond_to do |format|
      format.html { redirect_to hash_tags_url, notice: 'Hash tag was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_hash_tag
      @hash_tag = HashTag.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def hash_tag_params
      params[:hash_tag]
    end
end
