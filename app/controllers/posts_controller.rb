class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :categories, only: [:index, :show, :notice, :homework, :lecture, :freeboard, :questions, :photo ]
  before_action :mainimg, only: [:index]
  before_action :authenticate_user!, except: [:index, :show, :notice, :homework, :lecture, :freeboard, :mypage, :mypost, :questions, :photo]
  # before_action :log_impression, :only=> [:show]
  load_and_authorize_resource
  
  # GET /posts
  # GET /posts.json
  
  before_filter :search_models
  
  def search_models
    @posts_search = Post.all
  end
  
  
  def index
    @posts = Post.all
    @posts = Post.order("created_at DESC").page(params[:page]).per(10)
    @mains = Main.all
    
    @post_n = Post.where(:category => ['공지사항'])
    @posts_n = @post_n.order("created_at DESC").limit(2)
    
    @post_h = Post.where(:category => ['과제', '과제제출'])
    @posts_h = @post_h.order("created_at DESC").limit(4)
    
    @post_l = Post.where(:category => '수업자료')
    @posts_l = @post_l.order("created_at DESC").limit(4)
    
    @post_f= Post.where(:category => '일반')
    @posts_f = @post_f.order("created_at DESC").limit(4)
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
    
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
    isMember = check_user
    puts isMember
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: 'Post was successfully created.' }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { render :show, status: :ok, location: @post }
      else
        format.html { render :edit }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    check_user
    @post.destroy #and return
    redirect_to posts_url
    # respond_to do |format|
    #   format.html { redirect_to posts_url, notice: 'Post was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end
  
  def notice
    @post = Post.where(:category => ['공지사항', '대문'])
    @posts = @post.order("created_at DESC").page(params[:page])
    authorize! :notice, @posts
  end
    
  def homework
    @post = Post.where(:category => ['과제', '과제제출'])
    @posts = @post.order("created_at DESC").page(params[:page])
    authorize! :homework, @posts
  end
  
  def lecture
    @post = Post.where(:category => '수업자료')
    @posts = @post.order("created_at DESC").page(params[:page])
    authorize! :lecture, @posts
  end
  
  def freeboard
    @post = Post.where(:category => '일반')
    @posts = @post.order("created_at DESC").page(params[:page])
    authorize! :freeboard, @posts
  end
  
  def questions
    @post = Post.where(:category => '질문')
    @posts = @post.order("created_at DESC").page(params[:page])
    authorize! :questions, @posts
  end
  
  def photo
    @post = Post.where(:category => ['대문', '사진'])
    @posts = @post.order("created_at DESC").page(params[:page]).per(9)
    # authorize! :homework, @posts
  end  
  
  def mypost
    @user = Post.where(:user_id => current_user)
    @users = @user.order("created_at DESC").page(params[:page])
    authorize! :mypost, @users
  end

private
  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
    @mains = Main.all
  end
  
  def categories
    @categories_10 = Array.new # 배열을 하나 새로 만든다.
    count = 0 # 카운트 변수를 0으로 초기화 (10개를 추출할거니깐 숫자 증가시킴)
    categories = Post.all.order("created_at DESC") # 최신 포스트를 모두 가져온 다음
    categories.each do |x| # each로 하나씩
      if count == 5 # 만약 카운트가 10이면 우리가 원하는 최신 포스트 10개를 다 순회했으므로
        break; # each 메서드 종료
      end
    @categories_10.push(x) # 만약 10번 안돌았으면 새로 만ㄷ
    count += 1
    end
    @mains = Main.all
  end
  
  def mainimg 
    @mainimg = Post.where(:category => '대문')
    mainimg_3 = @mainimg.order("created_at DESC").limit(3)
    @mainimg_3_1 = mainimg_3.first
    @mainimg_3_2 = mainimg_3.second
    @mainimg_3_3 = mainimg_3.third
  end
  
  def check_user
    if @post.user_id != current_user.id
      return false
    elsif current_user.has_role? 'member'
      return true  
    else 
      return false
    end
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def post_params
    params.require(:post).permit(:title, :content, :user_id, :category, :limit, :lecture, :attachment)
  end
  
  # def log_impression
  #   @hit_post = Post.find(params[:id])
  #   # this assumes you have a current_user method in your authentication system\
  #   if(current_user == true) 
  #     @hit_post.impressions.create(ip_address: request.remote_ip,user_id:current_user.id)
  #   else
  #     @hit_post.impressions.create(ip_address: request.remote_ip)
  #   end
  # end
end
