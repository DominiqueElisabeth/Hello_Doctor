class PostsController < ApplicationController
  before_action :set_post, only: %i[ show edit update destroy ]
  before_action :patient_required, only: %i[new edit update]



  # GET /posts or /posts.json
  def index
    @posts = Post.all.order(created_at: :asc)
  end

  # GET /posts/1 or /posts/1.json
  def show
    @appointments = @post.appointments.order("date", "time")
    @comments = @post.comments.all.order("created_at")
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    unless current_patient == @post.patient
      redirect_back fallback_location: posts_path, notice: 'User is not owner'
    end
  end

  # POST /posts or /posts.json
  def create
      @post = current_patient.posts.build(post_params)
          if @post.save
            age = Date.today.year - @post.dob.year
            @post.update(age: age)
            redirect_to posts_path,  notice: 'Post was successfully created.'
          else
            render :new
          end
        end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: "Post was successfully updated." }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url, notice: "Post was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end


    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:symptom, :age, :dob, :weight, :phone, :sex, :remark, :patient_id)
    end
end
