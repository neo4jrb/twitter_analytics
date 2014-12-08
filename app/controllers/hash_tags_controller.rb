class HashTagsController < ApplicationController
  before_action :set_hash_tag, only: [:show, :edit, :update, :destroy]

  # GET /hash_tags
  # GET /hash_tags.json
  def index
    @hash_tags = HashTag.all
    @top_with_tweet_counts = HashTag.top_with_tweet_counts(20)
  end

  def foo
    respond_to do |format|
      format.html {}
      format.json do
        render json: User.as(:user).limit(100).tweets(:tweet, :r).query.return(:user, :r, :tweet).to_graph_json
      end
    end
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


  def explore
    hash_tag_string = params[:hash_tag].tr('-', ' ') if params[:hash_tag]
    @hash_tag = HashTag.where(text: hash_tag_string).first
    if @hash_tag
      respond_to do |format|
        format.json do
          render :json => @hash_tag.local_graph_to_sigma_json
        end
      end
    else
      @top_hash_tag_counts = Hash[*current_user.notes(:note).user_hash_tags(:hash_tag).order("COUNT(note) DESC").limit(20).pluck(:hash_tag, "COUNT(note)").flatten]
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
